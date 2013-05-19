class Youtube < ActiveRecord::Base
	audited
	has_associated_audits
  default_scope includes(:performances => [:artists, :compositions])
	has_many :performances, inverse_of: :youtube, conditions: { unlinked: false }
  has_one :channel, class_name: 'User', foreign_key: 'youtube_channel', primary_key: 'channel_id'
	attr_accessible :video_id
  attr_accessor :new_content, :api_data
  # new_content: Captures all artists and compositions not present in database to prevent duplicated values.
  before_validation :fill_youtube_particulars, unless: Proc.new { |p| channel_id.present? }
	validates :video_id, length: { is: 11 }, presence: true, uniqueness: { case_sensitive: true }
	validates_presence_of :performances, :channel_id
	validates_associated :performances

	def to_param
		video_id
	end

	def modify(p)
    # Cleanse performance hash of empty values.
    p[:perf].delete_if do |k, v|
      v["comp"].delete_if { |comp_k, comp_v| comp_v["t"].blank? }
      v["artist"].delete_if { |artist_k, artist_v| artist_v["n"].blank? }
      v["comp"].empty?
    end
    # Detect changes for existing Youtube.
    if !new_record?
      if !changes?(p[:perf].values)
        errors[:base] << "There are no changes."
        return false
      end
      if p[:timestamp] != updated_at.to_s
        errors[:base] << "Someone else has edited."
        return false
      end
    end
		# Validate video_id is embeddable and in Music category. And exists.
    transaction do
      self.new_content = { artists: [], compositions: [] } 
      new_record? ? add_performances(p[:perf]) : edit_performances(p[:perf])
      self.new_content = nil
      save
    end
	end

	private
  def changes?(edited_performances)
    # edited_performances: values of incoming performance hash.
    # Generate array of incoming, non-empty, existing ids.
    edited_compositions = edited_performances.map do |v|
      v["comp"].values.map do |comp_v|
        unless comp_v["t"].blank?
          comp_v["id"].blank? ? comp_v["t"] : comp_v["id"].to_i
        end
      end
    end
    edited_artists = edited_performances.map do |v|
      v["artist"].values.map do |artist_v|
        unless artist_v["n"].blank?
          artist_v["id"].blank? ? artist_v["n"] : artist_v["id"].to_i
        end
      end
    end
    # Comparison of current ids and incoming ids.
    compositions_changed = edited_compositions !=
      performances.map { |v| v.composition_ids }
    artists_changed = edited_artists !=
      performances.map { |v| v.artist_ids }
    compositions_changed or artists_changed
  end

	def add_performances(performances_hash)
		performances_hash.values.each do |hash|
			performances << Performance.define_new(hash, new_content)
		end
	end

	def edit_performances(performances_hash)
		if performances.length >= performances_hash.length
      # If there are more or equal existing performances...
			performances.zip(performances_hash.values) do |current, incoming|
				incoming.present? ? current.redefine(incoming, new_content) :
          current.unlink
			end
		else
      # There are less existing performances...
			performances_hash.values.zip(performances) do |incoming, current|
        current.present? ? current.redefine(incoming, new_content) :
					(performances << Performance.define_new(incoming, new_content))
			end
		end
	end

  def fill_youtube_particulars 
    client = GoogleAPI.new_client
    youtube_api = client.discovered_api('youtube', 'v3')
    result = client.execute(
      api_method: youtube_api.videos.list,
      parameters: {
        id: video_id,
        part: 'snippet',
        fields: 'items(snippet(channelId))'
      }
    )
    self.channel_id = result.data.items[0].snippet.channelId
  end
end



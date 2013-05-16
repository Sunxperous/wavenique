class Youtube < ActiveRecord::Base
	audited
	has_associated_audits
  default_scope includes(:performances => [:artists, :compositions])
	has_many :performances, inverse_of: :youtube, conditions: { unlinked: false }
  has_one :channel, class_name: 'User', foreign_key: 'youtube_channel', primary_key: 'channel_id'
	attr_accessible :video_id
  attr_accessor :new_content, :api_data
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
		# Validate video_id is embeddable and in Music category. And exists.
    transaction do
      self.new_content = Performance.new
      if !new_record?
        if !changes?(p[:perf].values)
          errors[:base] << "There are no changes."
          return false
        end
        if p[:timestamp] == updated_at.to_s
          edit_performances(p[:perf])
          if performances.blank?
            raise ActiveRecord::Rollback
          end
        else
          errors[:base] << "Someone else has edited."
          return false
        end
      else
        add_performances(p[:perf])
      end
      self.new_content = nil
      save
    end
	end

	private
  def changes?(new_performances)
    new_compositions = new_performances.map do |v|
      v["comp"].values.map do |comp_v|
        comp_v["id"].blank? ? comp_v["t"] : comp_v["id"].to_i unless comp_v["t"].blank?
      end
    end
    compositions_changed = new_compositions != performances.map { |v| v.composition_ids }
    
    new_artists = new_performances.map do |v|
      v["artist"].values.map do |artist_v|
        artist_v["id"].blank? ? artist_v["n"] : artist_v["id"].to_i unless artist_v["n"].blank?
      end
    end
    artists_changed = new_artists != performances.map { |v| v.artist_ids }
    compositions_changed or artists_changed
  end

	def add_performances(performances_hash)
		performances_hash.values.each do |hash|
			performances << Performance.define_new(hash)
		end
    performances.each { |p| p.purge_new_duplicates }
	end

	def edit_performances(performances_hash)
		current_performances = performances.all
		if current_performances.length >= performances_hash.length
      # If there are more or equal existing performances...
			current_performances.zip(performances_hash.values) do |current, new|
				new.present? ? current.redefine(new) : current.unlink
			end
		else
      # There are less existing performances...
			performances_hash.values.zip(current_performances) do |new, current|
				if current.present?
					current.redefine(new)
				else
					performances << Performance.define_new(new)
				end
			end
		end
    performances.each { |p| p.purge_new_duplicates }
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



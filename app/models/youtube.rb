class Youtube < ActiveRecord::Base
	attr_accessible :video_id
  attr_accessor :new_content, :api_data, :warnings
	has_many :performances, inverse_of: :youtube
  has_one :channel, class_name: 'User', foreign_key: 'youtube_channel', primary_key: 'channel_id'
  before_validation :fill_youtube_particulars, unless: Proc.new { |p| channel_id.present? }
	validates :video_id, length: { is: 11 }, presence: true, uniqueness: { case_sensitive: true }
	validates_presence_of :performances, :channel_id
	validates_associated :performances

  scope :with_performances, includes(:performances => [:artists, :compositions])

	def to_param
		video_id
	end

  after_initialize do |youtube|
    youtube.warnings = []
  end

  def available?
    return if api_data.blank?
    if api_data.snippet.categoryId != '10'
      warnings << "YouTube video does not belong in the Music category."
    end
    if !api_data.status.embeddable
      warnings << "YouTube video is not embeddable."
    end
    if api_data.status.privacyStatus != 'public'
      warnings << "YouTube video is not made public."
    end
  end

  def retrieve_api_data
		client = GoogleAPI.new_client
		# Use a begin..catch block for Google API client executions.
    # Especially for users who revoked access.
		youtube_api = client.discovered_api('youtube', 'v3')
		result = client.execute(
			api_method: youtube_api.videos.list,
			parameters: {
				id: video_id,
				part: 'snippet,status',
				fields: 'items(status(embeddable,privacyStatus),snippet(title,categoryId,channelId,channelTitle))'
			}
			# Parameters to be different for cached video data.
		)
    self.api_data = result.data.items[0]
    available?
  end

  def related
    client = GoogleAPI.new_client
    youtube_api = client.discovered_api('youtube', 'v3')
    result = client.execute(
      api_method: youtube_api.search.list,
      parameters: {
        part: 'id, snippet',
        maxResults: 15,
        relatedToVideoId: video_id,
        type: 'video',
        videoEmbeddable: 'true',
        videoCategoryId: '10'
      }
    )
    result.data
  end

	def modify(p)
    # Cleanse performance hash of empty values.
    p[:perf].delete_if do |k, v|
      v["comp"].delete_if { |comp_k, comp_v| comp_v["t"].blank? }
      v["artist"].delete_if { |artist_k, artist_v| artist_v["n"].blank? }
      v["comp"].empty?
    end
    # Detect changes for existing Youtube.
    # Decouple into another function.
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
    retrieve_api_data
    transaction do
      self.new_content = { artists: [], compositions: [] } 
      new_record? ? add_performances(p[:perf]) : edit_performances(p[:perf])
      self.new_content = nil
      raise ActiveRecord::Rollback if !valid?
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

	def add_performances(incoming_perf_hash)
		incoming_perf_hash.values.each do |hash|
			performances << Performance.define_new(hash, new_content)
		end
	end

	def edit_performances(incoming_perf_hash)
		if performances.length >= incoming_perf_hash.length
      # If there are more or equal existing performances...
      zipped = performances.zip(incoming_perf_hash.values)
			zipped.each do |current, incoming|
				incoming.present? ? current.redefine(incoming, new_content) :
          performances.delete(current)
			end
		else
      # There are less existing performances...
			incoming_perf_hash.values.zip(performances) do |incoming, current|
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



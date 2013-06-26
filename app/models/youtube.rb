class Youtube < ActiveRecord::Base
  include Wave
	attr_accessible :video_id
	has_many :performances, inverse_of: :wave, as: :wave, conditions: { deleted_at: nil }
  belongs_to :channel,
    class_name: 'User',
    foreign_key: 'channel_id',
    primary_key: 'youtube_channel'
	validates :video_id,
    length: { is: 11 },
    presence: true,
    uniqueness: { case_sensitive: true },
    format: { with: /[a-zA-Z0-9_-]{11}/ }
  before_validation :fill_site_info, on: :create
	validates_presence_of :performances, :channel_id
	validates_associated :performances
  scope :with_performances, includes(:performances => [:artists, :compositions])
  alias_attribute :reference_id, :video_id

	def to_param
		video_id
	end

  def available?
    return (api_data.present? &&
            api_data.status.embeddable &&
            api_data.status.privacyStatus == 'public')
  end

  def music?
    api_data.snippet.categoryId == '10'
  end

  def api_data
    @api_data ||= GoogleAPI.youtube('videos', 'list', {
      id: self.video_id,
	  	part: 'snippet,status',
			fields: 'items(status(embeddable,privacyStatus),'\
        'snippet(title,categoryId,channelId,channelTitle))'
		}).items[0]
  end

  def related
    GoogleAPI.youtube('search', 'list', {
      part: 'id, snippet',
      maxResults: 15,
      relatedToVideoId: video_id,
      type: 'video',
      videoEmbeddable: 'true',
      videoCategoryId: '10'
    })
  end
  
  def clear_performances
    performances.each { |p| p.update_attribute(:deleted_at, Time.now) }
    self.performances = []
  end

	private
  def fill_site_info
    self.channel_id = GoogleAPI.youtube('videos', 'list', {
      id: self.video_id,
	  	part: 'snippet',
			fields: 'items(snippet(channelId))'
		}).items[0].snippet.channelId
  end
end

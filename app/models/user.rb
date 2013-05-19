class User < ActiveRecord::Base
	audited
  attr_accessible :google_id, :google_name, :youtube_channel
  before_save :create_remember_token
  validates_presence_of :google_id, :google_name, :google_refresh_token, :google_access_token
  validates_uniqueness_of :google_id
  after_create :fill_youtube_particulars 
  has_many :youtube_uploads, class_name: 'Youtube', foreign_key: 'channel_id', primary_key: 'youtube_channel'

  def playlists
    client = GoogleAPI.new_client(authorization: true, user: self)
    youtube_api = client.discovered_api('youtube', 'v3')
    result = client.execute(
      api_method: youtube_api.playlists.list,
      parameters: { 
        part: 'snippet',
        mine: true,
        fields: 'items(id,snippet/title),pageInfo/totalResults',
      }
    )
  end

  def self.google_sign_in(code)
    data, access_token, refresh_token = google_authentication(code)
		u = User.new(google_id: data.id, google_name: data.name) unless u = User.find_by_google_id(data.id)
		if refresh_token.present?
			u.google_refresh_token = refresh_token
		end
		u.google_access_token = access_token
    u.save
		u
  end
  
  private
  def self.google_authentication(code)
    client = GoogleAPI.new_client(authorization: true)
    client.authorization.code = code
    client.authorization.fetch_access_token!
    oauth_api = client.discovered_api('oauth2')
    result = client.execute(
      api_method: oauth_api.userinfo.v2.me.get,
      paramters: { fields: 'id,name' }
    )
    [result.data, client.authorization.access_token, client.authorization.refresh_token]
  end

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def fill_youtube_particulars 
    client = GoogleAPI.new_client(authorization: true, user: self)
    youtube_api = client.discovered_api('youtube', 'v3')
    result = client.execute(
      api_method: youtube_api.channels.list,
      parameters: {
        part: 'id',
        mine: true,
        fields: 'items(id)'
      }
    )
    if result.data.items.empty?
      update_attribute(:youtube_channel, "")
    else
      update_attribute(:youtube_channel, result.data.items[0].id)
    end
  end
end

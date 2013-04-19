class User < ActiveRecord::Base
  attr_accessible :google_id, :google_name, :google_refresh_token 
  before_save :create_remember_token
  validates_presence_of :google_id, :google_name, :google_refresh_token
  validates_uniqueness_of :google_id

  def playlists
    client = GoogleAPI.client
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

  def self.google_signin(code)
    client = GoogleAPI.client
    client.authorization.code = code
    client.authorization.fetch_access_token!

    oauth_api = client.discovered_api('oauth2')
    result = client.execute(
      api_method: oauth_api.userinfo.v2.me.get,
      paramters: { fields: 'id,name' }
    )

    u = User.create(google_id: result.data.id, google_name: result.data.name, google_refresh_token: client.authorization.refresh_token) unless u = User.find_by_google_id(result.data.id)
    u
  end
  
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end

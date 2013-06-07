module GoogleAPI
	CLIENT_ID = '863784091693.apps.googleusercontent.com'
	CLIENT_SECRET = '-rfqVDdlAgD1PuZf3e0sLVdx'
	REDIRECT_URI = 'http://localhost:3000/callback/google/'
	APPLICATION_NAME = 'Wavenique'
	APPLICATION_VERSION = '0'
  KEY = 'AIzaSyBpEKVvW89LNQZSOdp23XdMjQFVCFhukv8'

	def self.new_client(options = {})
    # Generate default client.
		client = Google::APIClient.new(
      application_name: APPLICATION_NAME,
      application_version: APPLICATION_VERSION,
      key: KEY
    )
    # If there is a need for authorization...
    if options[:authorization]
      client.authorization.client_id = CLIENT_ID
      client.authorization.client_secret = CLIENT_SECRET
      client.authorization.redirect_uri = REDIRECT_URI
      # If user tokens are required...
      if options[:user]
        client.authorization.access_token = options[:user].access_token
        client.authorization.refresh_token = options[:user].refresh_token
      end
    else
      client.authorization = nil
		end
    client
	end

  def self.authentication(code)
    client = self.new_client(authorization: true)
    client.authorization.code = code
    client.authorization.fetch_access_token!
    oauth_api = client.discovered_api('oauth2')
    result = client.execute(
      api_method: oauth_api.userinfo.v2.me.get,
      paramters: { fields: 'id,name' }
    )
    [result.data, client.authorization.access_token, client.authorization.refresh_token]
  end

  def self.youtube(alpha, beta, parameters)
    client = self.new_client
    youtube_api = client.discovered_api('youtube', 'v3')
    result = client.execute(
      api_method: youtube_api.send(alpha).send(beta),
      parameters: parameters
    )
    result.data
  end
end

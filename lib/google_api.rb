module GoogleAPI
	CLIENT_ID = '863784091693.apps.googleusercontent.com'
	CLIENT_SECRET = '-rfqVDdlAgD1PuZf3e0sLVdx'
	REDIRECT_URI = 'http://localhost:3000/callback/'
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
        client.authorization.access_token = options[:user].google_access_token
        client.authorization.refresh_token = options[:user].google_refresh_token
      end
    else
      client.authorization = nil
		end
    client
	end
end

module GoogleAPI
	CLIENT_ID = '863784091693.apps.googleusercontent.com'
	CLIENT_SECRET = '-rfqVDdlAgD1PuZf3e0sLVdx'
	REDIRECT_URI = 'http://localhost:3000/callback/'
	APPLICATION_NAME = 'Wavenique'
	APPLICATION_VERSION = '0'

	def self.new_client
		client = Google::APIClient.new(application_name: APPLICATION_NAME, application_version: APPLICATION_VERSION)
		client.authorization.client_id = CLIENT_ID
		client.authorization.client_secret = CLIENT_SECRET
		client.authorization.redirect_uri = REDIRECT_URI
		@client = client
	end

	def self.client
		@client ||= new_client
	end

	def self.access_token=(access_token)
		self.client.authorization.access_token = access_token
	end

	def self.refresh_token=(refresh_token)
		self.client.authorization.refresh_token = refresh_token
	end

end

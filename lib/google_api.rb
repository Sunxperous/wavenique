module GoogleAPI
	CLIENT_ID = '863784091693.apps.googleusercontent.com'
	CLIENT_SECRET = '-rfqVDdlAgD1PuZf3e0sLVdx'
	REDIRECT_URI = 'http://localhost:3000/callback/'

	def self.new_client
		client = Google::APIClient.new
		client.authorization.client_id = CLIENT_ID
		client.authorization.client_secret = CLIENT_SECRET
		client.authorization.redirect_uri = REDIRECT_URI
		@client = client
	end

	def self.client
		@client ||= new_client
	end

end

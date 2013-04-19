require 'spec_helper'

describe 'Google sign in' do
	context 'with allowed access' do
		it 'redirects to user' do
			#User.stub(:google_signin) { @user = FactoryGirl.create(:user) }
			google_api_client = double()
			GoogleAPI.stub(:client) { google_api_client }
			google_api_client.stub_chain(:authorization, :code=)
			google_api_client.stub_chain(:authorization, :fetch_access_token!)
			#google_api_client.stub(:discovered_api)
			google_api_client.stub_chain(:discovered_api, :userinfo, :v2, :me, :get)
			google_api_client.should_receive(:execute) { 'wtf' }
			get '/callback', code: 'random'
			expect(response).to redirect_to(@user)
		end
	end

	context 'with denied access' do
		it 'redirects to root' do
			get '/callback', error: 'access_denied'
			expect(response).to redirect_to(root_path)
		end
	end
end

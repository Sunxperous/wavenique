require 'spec_helper'

describe 'Google sign in' do
	context 'with allowed access' do
		it 'redirects to user' do
			User.should_receive(:google_sign_in) { @user = FactoryGirl.create(:user) }
			User.any_instance.stub(:playlists) # Ignore Google API request.
			get '/callback', code: 'present'
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

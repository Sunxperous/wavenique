require 'spec_helper'

describe SessionsController do
  describe 'GET #google' do
    specify 'with code redirects to user' do
      user = FactoryGirl.create(:user)
      User::Google.stub(:sign_in) { user }
      get :google, code: 'code'
      expect(response).to redirect_to(user)
    end
    specify 'without code redirects to root' do
      get :google
      expect(response).to redirect_to(root_path)
    end 
    specify 'by signed in user redirects to user' do
      user = FactoryGirl.create(:user)
      sign_in user
      get :google
      expect(response).to redirect_to(user)
    end
  end
end

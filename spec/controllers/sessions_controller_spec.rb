require 'spec_helper'

describe SessionsController do
  context 'GET #google' do
    specify 'with code signs in and redirects to user' do
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
      controller.stub(:current_user) { user }
      get :google
      expect(response).to redirect_to(user)
    end
  end
  context 'GET #destroy' do
    specify 'redirects to root' do
      get :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end

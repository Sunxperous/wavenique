require 'spec_helper'

describe Tsunami::UsersController do
  context 'GET #index' do
    include_examples 'accessible by admins only' do
      let(:action) { -> { get :index } }
    end
    specify 'assigns @users' do
      admin = FactoryGirl.create(:admin)
      controller.stub(:current_user) { admin }
      FactoryGirl.create_list(:user_google, 25)
      users = User.all
      get :index
      expect(assigns[:users]).to eq(users)
    end
  end
end

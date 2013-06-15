require 'spec_helper'

feature 'Tsunami::Users' do
  background do
    FactoryGirl.create_list(:user_google, 25)
  end
  scenario 'displays full list of users' do
    sign_in FactoryGirl.create(:admin)
    visit tsunami_users_path
    expect(page).to have_table('users')
  end
end

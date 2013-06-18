require 'spec_helper'

feature 'Tsunami::Users' do
  let(:admin) { FactoryGirl.create(:admin) }
  background do
    FactoryGirl.create_list(:user_google, 25)
  end
  scenario 'displays full list of users' do
    sign_in admin
    visit tsunami_users_path
    expect(page).to have_table('users')
    expect(page.find('table#users')).to have_selector('tr.user', count: 26)
  end
end

require 'spec_helper'

feature 'Tsunami' do
  background do
    sign_in FactoryGirl.create(:admin)
    visit root_path
  end
  scenario 'is accessible to admins' do
    expect(page).to have_link('Tsunami', href: tsunami_path)
    click_link 'Tsunami'
    expect(current_path).to eq(tsunami_path)
  end
  scenario 'has user management link' do
    click_link 'Tsunami'
    expect(page).to have_link('Manage Users', href: tsunami_users_path)
  end
end

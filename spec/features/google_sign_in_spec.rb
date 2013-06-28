require 'spec_helper'
# Place private information in a .yml file in the future.

feature 'Google sign in', js: true do
  context 'for new user' do
    before do
      visit root_path
      click_link 'Sign in'
      fill_in 'Email', with: 'kenoriga@gmail.com'
      fill_in 'Password', with: '15runj3j'
      click_button 'Sign in'
    end
    scenario 'with denied access' do
      click_button 'No thanks' if page.has_content?('No thanks')
      click_button 'Cancel' if page.has_content?('Cancel')
      expect(current_path).to eq(root_path)
    end
    scenario 'with allowed access' do
      click_button 'Allow access' if page.has_content?('Allow access')
      click_button 'Accept' if page.has_content?('Accept')
      expect(page).to have_text('Sign out')
      expect(page).to have_text('Wang Jun Sun')
    end
  end
  context 'for existing user' do
    background do
      visit root_path
      click_link 'Sign in'
      fill_in 'Email', with: 'kenoriga@gmail.com'
      fill_in 'Password', with: '15runj3j'
      click_button 'Sign in'
      click_button 'Allow access' if page.has_content?('Allow access')
      click_button 'Accept' if page.has_content?('Accept')
      click_link 'Sign out'
    end
    scenario 'with allowed access' do
      visit root_path
      click_link 'Sign in'
      expect(page).to_not have_content('Allow access')
      expect(page).to_not have_content('Accept')
      expect(page).to have_text('Sign out')
      expect(page).to have_text('Wang Jun Sun')
    end
  end
end


require 'spec_helper'
# Place private information in a .yml file in the future.

feature 'Google sign in' do
  context 'for new user' do
    scenario 'with denied access', js: true do
      visit root_path
      click_link 'Sign in'
      fill_in 'Email', with: 'kenoriga@gmail.com'
      fill_in 'Password', with: '15runj3j'
      click_button 'Sign in'
      if page.has_content?('No thanks')
        click_button 'No thanks'
        expect(current_path).to eq(root_path)
      end
    end
    scenario 'with allowed access', js: true do
      visit root_path
      click_link 'Sign in'
      fill_in 'Email', with: 'kenoriga@gmail.com'
      fill_in 'Password', with: '15runj3j'
      click_button 'Sign in'
      click_button 'Allow access' if page.has_content?('Allow access')
      click_button 'Accept' if page.has_content?('Accept')
      #expect(current_path).to eq('/users/1')
      expect(page).to have_text('Sign out')
      expect(page).to have_text('Wang Jun Sun')
    end
  end
  context 'for existing user', js: true do
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


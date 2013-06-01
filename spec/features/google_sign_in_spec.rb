require 'spec_helper'

feature 'Google sign in' do
	scenario 'with allowed access' do
	end

	scenario 'with denied access', js: true do
		visit root_path
		click_link 'Sign in'
		fill_in 'Email', with: 'kenoriga@gmail.com'
		fill_in 'Password', with: '15runj3j'
		click_button 'Sign in'
		click_button 'Allow access'
		page.should have_selector('h1', text: 'Wang Jun Sun')
	end
end


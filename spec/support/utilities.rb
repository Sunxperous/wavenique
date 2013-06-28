require 'spec_helper'

def sign_in(user)
  User::Google.stub(:sign_in) { user }
  visit '/callback/google/?code=sign_in'
end

def fill_autocomplete(selector, text)
  page.execute_script %Q{$('#{ selector }').val('#{ text }').focus().keydown()}
end

def select_autocomplete(text)
  page.find('ul.ui-autocomplete', text: text) # Activates Capybara wait.
  page.execute_script %Q{$('.ui-menu-item:contains("#{ text }")').find('a').click()}
end

def fill_and_select_autocomplete(selector, text)
  fill_autocomplete(selector, text)
  select_autocomplete(text)
end


shared_examples 'accessible by admins only' do
  describe 'redirects to root' do
    specify 'for non-admins' do
      controller.stub(:current_user) { FactoryGirl.create(:user) }
      action.call
      expect(response).to redirect_to(root_path)
    end
    specify 'for visitors' do
      action.call
      expect(response).to redirect_to(root_path)
    end
  end
  specify 'returns http success' do
    controller.stub(:current_user) { FactoryGirl.create(:admin) }
    action.call
    expect(response).to be_success
  end
end


require 'spec_helper'

feature 'PerformancesForm:' do
  scenario 'New Youtube page has form' do
    visit '/youtube/x4eVFXT9eIw'
    expect(find('main')).to have_selector('form')
  end
end

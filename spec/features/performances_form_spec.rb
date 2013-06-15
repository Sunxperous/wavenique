require 'spec_helper'

feature 'PerformancesForm:' do
  pending 'New Youtube page has form' do
    visit '/youtube/x4eVFXT9eIw'
    expect(find('main')).to have_selector('form')
  end
end

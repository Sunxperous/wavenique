require 'spec_helper'

feature 'Artist aliases', js: true do
  let!(:artist) { FactoryGirl.create(:artist, name: 'Garie') }
  let!(:aliases) { FactoryGirl.create_list(
    :artist_alias,
    3,
    artist: artist
  ) }

  background do
    visit artist_aliases_path(artist)
  end

  scenario 'displays the list of aliases' do
    expect(page).to have_css('li', count: 3)
  end
  scenario 'displays the most proper name as a header' do
    expect(page).to have_css('h1', 'Garie')
  end
  context 'new addition' do
    scenario 'inserts the new alias' do
      fill_in 'new_alias', with: 'Gary'
      click_button 'Submit'
      expect(page).to have_text('Gary')
    end
  end
end

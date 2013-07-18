require 'spec_helper'

feature 'Artist show', js: true do
  let!(:artist) { FactoryGirl.create(:artist, name: 'JJ Lin') }
  background do
    %w{LWV-f6dMN3Q x9Gwr-iz55I BqV7skPEcWo OXMSnFtSlHc m0z1XfphYzU}.each do |video_id|
      FactoryGirl.create(
        :youtube_with_perf,
        video_id: video_id,
        perf: [{ a: [artist], c: 1 }]
      )
    end
    Youtube.any_instance.stub(:fill_site_info)
    sign_in FactoryGirl.create(:user)
    visit artist_path artist
  end
  scenario 'contains the artist name' do
    expect(page).to have_text(artist.name)
  end
  scenario 'displays the related performances' do
    expect(page).to have_css('li', count: 5)
  end
  
  scenario 'has a link to edit aliases' do
    expect(page).to have_link('Edit Aliases')
  end
end

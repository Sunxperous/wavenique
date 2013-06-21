require 'spec_helper'
include YoutubeHelper

feature 'Youtube show', js: true do
  context 'for an invalid video' do
    scenario 'shows error message' do
      visit youtube_path id: 'qwertyui_'
      expect(page).to have_text('no longer available')
      expect(page).to_not have_selector('iframe')
    end
  end
  context 'for a valid, new video' do
    # JJ LIn: Remember +++ ++ by OceanButterfliesUS
    let!(:youtube) { FactoryGirl.build(
      :youtube,
      video_id: 'NCE8xoq7vgk',
      channel_id: nil
    ) }
    background do
      visit youtube_path id: youtube.video_id
    end
    scenario 'embeds an iframe' do
      expect(page).to have_selector('iframe')
    end
    scenario 'links to the YouTube video via its title' do
      expect(page).to have_link(
        youtube.api_data.snippet.title,
        href: video_link_for(youtube.video_id)
      )
    end
    scenario 'links to the YouTube channel via its name' do
      expect(page).to have_link(
        youtube.api_data.snippet.channelTitle,
        href: channel_link_for(youtube.api_data.snippet.channelId)
      )
    end
    scenario 'shows the form to add performances' do
      expect(find('section.main')).to have_selector('form')      
      form = find('section.main').find('form')
      expect(form['action']).to eq("/modify/youtube/#{youtube.video_id}")
    end
    scenario 'links up to 15 related YouTube videos'
  end
end

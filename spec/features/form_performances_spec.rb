require 'spec_helper'

feature 'Form::Performance object', js: true do
  before do
    Youtube.skip_callback :validation, :before, :fill_site_info
  end
  # JJ LIn: Remember +++ ++ by OceanButterfliesUS
  let!(:youtube) { FactoryGirl.build(
    :youtube,
    video_id: 'NCE8xoq7vgk',
    channel_id: nil
  ) }
  let!(:existing_a) { FactoryGirl.create(:artist, name: 'Lin Jun Jie') }
  let!(:existing_c) { FactoryGirl.create(:composition, title: 'Dismember') }
  background do
    sign_in FactoryGirl.create(:user)
    visit youtube_path id: youtube.video_id
  end
  scenario 'shows on YouTube video page' do
    expect(find('section.main')).to have_selector('form')      
    form = find('section.main').find('form')
    expect(form['action']).to eq("/modify/youtube/#{youtube.video_id}")
  end
  context 'elements' do
    let(:form) { find('section.main').find('form') }
    scenario 'has one title field and one artist field' do
      expect(form).to have_field('p_1_c_1_t', type: 'text', with: '')
      expect(form).to have_field('p_1_a_1_n', type: 'text', with: '')
    end
    scenario 'adds a title field' do
      click_button 'p[1]_add_title'
      expect(form).to have_field('p_1_c_2_t', type: 'text', with: '')
    end
    scenario 'adds an artist field' do
      click_button 'p[1]_add_artist'
      expect(form).to have_field('p_1_a_2_n', type: 'text', with: '')
    end
    scenario 'adds a performance fieldset' do
      click_button 'add_performance'
      expect(form).to have_field('p_2_c_1_t', type: 'text', with: '')
      expect(form).to have_field('p_2_a_1_n', type: 'text', with: '')
    end
    scenario 'has autocomplete for title field' do
      fill_autocomplete '#p_1_c_1_t', 'Dis'
      expect(page).to have_css('a.ui-corner-all', text: existing_c.title, visible: false)
    end
    scenario 'has autocomplete for artist field' do
      fill_autocomplete '#p_1_a_1_n', 'Jun'
      expect(page).to have_css('a.ui-corner-all', text: existing_a.name, visible: false)
    end
  end
end


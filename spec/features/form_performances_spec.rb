require 'spec_helper'

feature 'Form::Performance object', js: true do
  # 2013hito流行音乐奖
  # Bii, 梁文音, 鄧福如, 小宇
  # Sorry,Sorry, First Love, 遇见, 温柔, 七里香, 今天你要嫁给我, 日不落,
  # 洋葱, 对面的女孩看过来
  let!(:youtube) { FactoryGirl.build(
    :youtube,
    video_id: 'sNjQm9Qh6sI',
    channel_id: nil
  ) }
  let!(:bii) { FactoryGirl.create(:artist, name: 'Bii') }
  let!(:qilixiang) { FactoryGirl.create(:composition, title: '七里香') }
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
      fill_autocomplete '#p_1_c_1_t', '七里'
      expect(page).to have_css('.ui-menu-item', text: qilixiang.title, visible: false)
      select_autocomplete '七里香'
      expect(form).to have_field('p_1_c_1_t', type: 'text', with: '七里香')
    end
    scenario 'has autocomplete for artist field' do
      fill_autocomplete '#p_1_a_1_n', 'Bi'
      expect(page).to have_css('.ui-menu-item', text: bii.name, visible: false)
      select_autocomplete 'Bii'
      expect(form).to have_field('p_1_a_1_n', type: 'text', with: 'Bii')
    end
  end
  context 'submission' do
    specify 'changes wave performance info' do
      8.times { click_button 'add_performance' }
      fill_in 'p_1_c_1_t', with: 'Sorry, Sorry'
      fill_and_select_autocomplete '#p_1_a_1_n', 'Bii'
      fill_in 'p_2_c_1_t', with: 'First Love'
      fill_in 'p_2_a_1_n', with: '梁文音'
      fill_in 'p_3_c_1_t', with: '遇见'
      fill_in 'p_3_a_1_n', with: '鄧福如'
      fill_in 'p_4_c_1_t', with: '温柔'
      fill_in 'p_4_a_1_n', with: 'Bi'
      fill_and_select_autocomplete '#p_5_c_1_t', '七里香'
      fill_in 'p_5_a_1_n', with: '小宇'
      fill_in 'p_6_c_1_t', with: '今天你要嫁给我'
      click_button 'p[6]_add_artist'
      fill_in 'p_6_a_1_n', with: '小宇'
      fill_and_select_autocomplete '#p_6_a_2_n', 'Bii'
      fill_in 'p_7_c_1_t', with: '日不落'
      fill_in 'p_7_a_1_n', with: '鄧福如'
      fill_in 'p_8_c_1_t', with: '洋葱'
      fill_in 'p_8_a_1_n', with: '梁文音'
      fill_in 'p_9_c_1_t', with: '对面的女孩看过来'
      3.times { click_button 'p[9]_add_artist' }
      fill_in 'p_9_a_1_n', with: '梁文音'
      fill_in 'p_9_a_2_n', with: '鄧福如'
      fill_in 'p_9_a_3_n', with: '小宇'
      fill_and_select_autocomplete '#p_9_a_4_n', 'Bii'
      click_button 'Submit'
      sleep(2)
      expect(find('section.main')).to_not have_selector('form')
      expect(page).to have_link('Bii', href: artist_path(bii))
      expect(page).to have_link('七里香', href: composition_path(qilixiang))
    end
  end
end


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
  scenario 'shows on YouTube video page' do
    sign_in FactoryGirl.create(:user)
    visit youtube_path id: youtube.video_id
    expect(find('main')).to have_selector('form')      
    form = find('main').find('form')
    expect(form['action']).to eq("/modify/youtube/#{youtube.video_id}")
  end
  context 'elements' do
    let(:form) { find('main').find('form') }
    background do
      sign_in FactoryGirl.create(:user)
      visit youtube_path id: youtube.video_id      
    end
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
      click_button 'formp_add_performance'
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
    background do
      FactoryGirl.create(:label, name: 'Cover', id: 1)
      FactoryGirl.create(:label, name: 'Live', id: 2)
    end
    describe 'for new wave' do
      background do
        sign_in FactoryGirl.create(:user)
        visit youtube_path id: youtube.video_id
        8.times { click_button 'formp_add_performance' }
        fill_in 'p_1_c_1_t', with: 'Sorry, Sorry'
        fill_and_select_autocomplete '#p_1_a_1_n', 'Bii'
        check 'p_1l_1'
        check 'p_1l_2'
        fill_in 'p_2_c_1_t', with: 'First Love'
        fill_in 'p_2_a_1_n', with: '梁文音'
        check 'p_2l_1'
        check 'p_2l_2'
        fill_in 'p_3_c_1_t', with: '遇见'
        fill_in 'p_3_a_1_n', with: '鄧福如'
        check 'p_3l_1'
        check 'p_3l_2'
        fill_in 'p_4_c_1_t', with: '温柔'
        fill_and_select_autocomplete '#p_4_a_1_n', 'Bii'
        check 'p_4l_1'
        check 'p_4l_2'
        fill_and_select_autocomplete '#p_5_c_1_t', '七里香'
        fill_in 'p_5_a_1_n', with: '小宇'
        check 'p_5l_1'
        check 'p_5l_2'
        fill_in 'p_6_c_1_t', with: '今天你要嫁给我'
        click_button 'p[6]_add_artist'
        fill_in 'p_6_a_1_n', with: '小宇'
        fill_and_select_autocomplete '#p_6_a_2_n', 'Bii'
        check 'p_6l_1'
        check 'p_6l_2'
        fill_in 'p_7_c_1_t', with: '日不落'
        fill_in 'p_7_a_1_n', with: '鄧福如'
        check 'p_7l_1'
        check 'p_7l_2'
        fill_in 'p_8_c_1_t', with: '洋葱'
        fill_in 'p_8_a_1_n', with: '梁文音'
        check 'p_8l_1'
        check 'p_8l_2'
        fill_in 'p_9_c_1_t', with: '对面的女孩看过来'
        3.times { click_button 'p[9]_add_artist' }
        fill_in 'p_9_a_1_n', with: '梁文音'
        fill_in 'p_9_a_2_n', with: '鄧福如'
        fill_in 'p_9_a_3_n', with: '小宇'
        fill_and_select_autocomplete '#p_9_a_4_n', 'Bii'
        check 'p_9l_1'
        check 'p_9l_2'
        click_button 'Submit'
        sleep(3)
      end
      scenario 'changes the form and performance info elements' do
        expect(find('main')).to_not have_selector('form')
        expect(page).to have_link('Bii', href: artist_path(bii), count: 4)
        expect(page).to have_link('七里香', href: composition_path(qilixiang))
        liangwenyin_url = page.find_link('梁文音', match: :first, exact: true)[:href]
        expect(page).to have_link('梁文音', href: liangwenyin_url, count: 3)
        expect(page).to have_css('.label', count: 18)
      end
    end
    describe 'for existing wave' do
      let!(:youtube) { FactoryGirl.create(
        :youtube_with_perf,
        video_id: 'XdDNdWak86Q',
        perf: [{ a: ['Wrong Kim Jong Kook'],
          c: ['Men Are All Like That Incorrect'] }]
      ) }
      let!(:kimjongkook) { FactoryGirl.create(:artist, name: 'Kim Jong Kook') }
      background do
        sign_in FactoryGirl.create(:admin)
        visit youtube_path id: youtube.video_id
        fill_in 'p_1_c_1_t', with: 'Men Are All Like That'
        fill_and_select_autocomplete '#p_1_a_1_n', 'Kim Jong Kook'
        click_button 'Submit'
        sleep(3)
      end
      scenario 'changes the form and performance info elements' do
        expect(find('main')).to_not have_selector('form')
        expect(page).to have_link('Kim Jong Kook', href: artist_path(kimjongkook), exact: true)
        expect(page).to have_link('Men Are All Like That', exact: true)
      end
    end
  end
end


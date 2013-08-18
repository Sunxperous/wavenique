require 'spec_helper'

FORMP_SECTION_ID = '#formp'

feature 'Form::Performance object', js: true do
  background do
    FactoryGirl.create(:label, name: 'Cover', id: 1)
    FactoryGirl.create(:label, name: 'Live', id: 2)
    sign_in FactoryGirl.create(:user)
    visit youtube_path id: youtube.video_id
  end

  context 'for a new YouTube Wave' do
    # http://www.youtube.com/watch?v=WiovdYLIT_4
    # 淘汰 by 陈奕迅, and
    # 说好的幸福呢, 淘汰, 青花瓷 by 周杰伦.
    let!(:youtube) { FactoryGirl.build(
      :youtube,
      video_id: 'WiovdYLIT_4',
      channel_id: nil
    ) }
    let!(:eason) { FactoryGirl.create(:artist, name: '陈奕迅') }
    let!(:qinghuaci) { FactoryGirl.create(:composition, title: '青花瓷') }

    describe 'contains form elements which' do
      let(:form) { find('main').find(FORMP_SECTION_ID).find('form') }

      scenario 'displays the form' do
        expect(find('main').find(FORMP_SECTION_ID)).to have_selector('form')
      end
      scenario 'points to the correct action' do
        expect(form['action']).to eq("/modify/youtube/#{youtube.video_id}")
      end

      scenario 'has one title field' do
        expect(form).to have_field('p_1_c_1_t', type: 'text', with: '')
      end
      scenario 'has one artist field' do
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
        expect(form).to have_selector('#p\\[2\\]')
      end

      scenario 'has autocomplete for title field' do
        fill_autocomplete '#p_1_c_1_t', '青花'
        expect(page).to have_css('.ui-menu-item', text: qinghuaci.title, visible: false)
        select_autocomplete qinghuaci.title
        expect(form).to have_field('p_1_c_1_t', type: 'text', with: qinghuaci.title)
      end
      scenario 'has autocomplete for artist field' do
        fill_autocomplete '#p_1_a_1_n', '陈奕'
        expect(page).to have_css('.ui-menu-item', text: eason.name, visible: false)
        select_autocomplete eason.name
        expect(form).to have_field('p_1_a_1_n', type: 'text', with: eason.name)
      end
    end

    describe 'submission' do
      background do
        click_button 'formp_add_performance'

        fill_in 'p_1_c_1_t', with: '淘汰'
        fill_and_select_autocomplete '#p_1_a_1_n', eason.name
        check 'p_1l_2'

        2.times { click_button 'p[2]_add_title' }
        fill_in 'p_2_c_1_t', with: '说好的幸福呢'
        fill_in 'p_2_c_2_t', with: '淘汰'
        fill_and_select_autocomplete '#p_2_c_3_t', qinghuaci.title
        fill_in 'p_2_a_1_n', with: '周杰伦'
        check 'p_2l_2'

        click_button 'Submit'
        sleep(2)
      end

      scenario 'changes the form and performance info elements' do
        expect(find('main')).to_not have_selector('form')
        # Existing artist.
        expect(page).to have_link(eason.name, href: artist_path(eason))
        # Existing composition.
        expect(page).to have_link(qinghuaci.title, href: composition_path(qinghuaci))
        # Repeated composition.
        taotai_url = page.find_link('淘汰', match: :first, exact: true)[:href]
        expect(page).to have_link('淘汰', href: taotai_url, count: 2)
        # Non-existing, non-repeating values.
        expect(page).to have_link('周杰伦')
        expect(page).to have_link('说好的幸福呢')
        # Labels.
        expect(page).to have_css('.label', count: 2)
      end
    end
  end

  context 'for an existing YouTube Wave object' do
    describe 'submission' do
      # http://www.youtube.com/watch?v=ZHJiMrUaxm0
      # 开不了口 by 周杰伦, and
      # 给我一首歌的时间 by 周杰伦 and 蔡依林.
      let!(:youtube) { FactoryGirl.build(
        :youtube,
        video_id: 'ZHJiMrUaxm0'
      ) }
      let!(:kaibuliaokou) { FactoryGirl.create(:composition, title: '开不了口') }
      let!(:jolintsai) { FactoryGirl.create(:artist, name: '蔡依林') }

      background do
        click_button 'formp_add_performance'
        fill_and_select_autocomplete '#p_1_c_1_t', kaibuliaokou.title
        fill_in 'p_1_a_1_n', with: '周杰伦'
        check 'p_1l_2'

        click_button 'p[2]_add_artist'
        fill_in 'p_2_c_1_t', with: '给我一首歌的时间'
        fill_in 'p_2_a_1_n', with: '周杰伦'
        fill_and_select_autocomplete '#p_2_a_2_n', jolintsai.name
        check 'p_2l_1'
        check 'p_2l_2'

        click_button 'Submit'
        sleep(2)
      end

      scenario 'changes the form and performance info elements' do
        expect(find('main')).to_not have_selector('form')
        # Existing artist.
        expect(page).to have_link(jolintsai.name, href: artist_path(jolintsai))
        # Existing composition.
        expect(page).to have_link(kaibuliaokou.title, href: composition_path(kaibuliaokou))
        # Repeated arist.
        jaychou_url = page.find_link('周杰伦', match: :first, exact: true)[:href]
        expect(page).to have_link('周杰伦', href: jaychou_url, count: 2)
        expect(page).to have_css('.label', count: 3)
      end
    end

  end
end


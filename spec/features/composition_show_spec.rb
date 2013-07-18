require 'spec_helper'

feature 'Composition show', js: true do
  let!(:composition) { FactoryGirl.create(:composition, title: 'Paradise') }
  background do
    %w{1G4isv_Fylg Cgovv8jWETM K2YSo8Z_-a4 H6_NDTisdKU vPcYDPOOkT4}.each do |video_id|
      FactoryGirl.create(
        :youtube_with_perf,
        video_id: video_id,
        perf: [{ a: 1, c: [composition] }]
      )
    end
    Youtube.any_instance.stub(:fill_site_info)
    sign_in FactoryGirl.create(:user)
    visit composition_path composition
  end
  scenario 'contains the composition title' do
    expect(page).to have_text(composition.title)
  end
  scenario 'displays the related performances' do
    expect(page).to have_css('li', count: 5)
  end
  
end

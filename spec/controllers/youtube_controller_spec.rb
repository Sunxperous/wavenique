require 'spec_helper'

describe YoutubeController do
  before do
    Youtube.any_instance.stub(:related) { 'related videos' }
    Youtube.any_instance.stub(:api_data) { OpenStruct.new(
      status: OpenStruct.new(
        embeddable: true,
        privacyStatus: 'public'
      ),
      snippet: OpenStruct.new(
        categoryId: '10'
      )
    ) }
    Youtube.skip_callback :validation, :before, :fill_site_info
  end
  specify 'requests with invalid video id' do
    get :show, id: 'qwertyuiop%'
    expect(response).to render_template('unavailable')
  end
  context 'GET #show' do
    let!(:youtube) { FactoryGirl.build(
      :youtube_with_perf,
      channel_id: nil
    ) }
    context 'for new, valid Youtube' do
      before do
        controller.stub(:current_user) { FactoryGirl.create(:user) }
        get :show, id: youtube.video_id
      end
      specify 'assigns @form_performance' do
        expect(assigns(:form_performance)).to_not eq(nil)
      end
      specify 'assigns @youtube' do
        expect(assigns(:youtube).attributes).to eq(youtube.attributes)
      end
      specify 'renders show template' do
        expect(response).to be_success
        expect(response).to render_template('show')
      end
    end
    context 'for existing Youtube' do
      before do
        youtube.channel_id = 'channel_id'
        youtube.save!
        controller.stub(:current_user) { FactoryGirl.create(:user) }
        get :show, id: youtube.video_id
      end
      specify 'does not assign @form_performance' do
        expect(assigns(:form_performance)).to eq(nil)
      end
    end
    context 'for invalid Youtube' do
      before { Youtube.any_instance.stub(:api_data) { false } }
      specify 'renders error template' do
        get :show, id: youtube.video_id
        # Expect reponse to be HTTP "Not-found" error.
        expect(response).to render_template('unavailable')
      end
      specify 'does not assign @related' do
        expect(assigns(:related)).to eq(nil)
      end
    end
  end
end

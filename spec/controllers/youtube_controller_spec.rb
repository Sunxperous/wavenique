require 'spec_helper'

describe YoutubeController do
  before do
    Youtube.any_instance.stub(:related) { 'related videos' }
    Youtube.any_instance.stub(:api_data) { OpenStruct.new(
      status: OpenStruct.new(
        embeddable: true,
        privacyStatus: 'public'
    )) }
  end
  specify 'requests with invalid video id' do
    get :show, id: 'qwertyuiop%'
    expect(response).to render_template('unavailable')
  end
  context 'GET #show' do
    let!(:youtube) { FactoryGirl.create(
        :youtube_with_perf,
        perf: [ { a: 1, c: 1 } ]
    ) }
    context 'for valid Youtube' do
      before do
        get :show, id: youtube.video_id
      end
      specify 'assigns @youtube' do
        expect(assigns(:youtube)).to eq(youtube)
      end
      specify 'assigns @related' do
        expect(assigns(:related)).to_not eq(nil)
      end
      specify 'renders show template' do
        expect(response).to be_success
        expect(response).to render_template('show')
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

require 'spec_helper'

describe ArtistsController do
  context 'GET #find' do
    let!(:names) { FactoryGirl.create_list(:artist, 11)[0..9].map(&:aliases).flatten }
    specify 'assigns @artists' do
      get :find, name: 'Name'
      expect(assigns(:names)).to match_array(names)
    end
    specify 'does not render html' do
      get :find, name: 'Name'
      expect(response.status).to eq(406)
    end
    specify 'renders json' do
      get :find, name: 'Name', format: :json
      expect(response).to be_success
      expect(response.body).to eq(names.to_json)
    end
  end

  context 'GET #show' do
    let!(:artist) { FactoryGirl.create(:artist) }
    before do
      Youtube.any_instance.stub(:fill_site_info) { true }
      get :show, id: artist.id
    end
    specify 'assigns @artist' do
      expect(assigns(:artist)).to eq(artist)
    end
    specify 'assigns @performances' do
      performances = FactoryGirl.create_list(
        :youtube_with_perf,
        5,
        perf: [{ a: [artist], c: 1 }]
      ).map(&:performances).flatten
      expect(assigns(:performances)).to match_array(performances)
    end
    specify 'renders show template' do
      expect(response).to be_success
      expect(response).to render_template('show')
    end
  end
end

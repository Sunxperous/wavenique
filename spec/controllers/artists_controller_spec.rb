require 'spec_helper'

describe ArtistsController do
  context 'GET #find' do
    let!(:artists) { FactoryGirl.create_list(:artist, 11)[0..9] }
    specify 'assigns @artists' do
      get :find, name: 'Name'
      expect(assigns(:artists)).to eq(artists)
    end
    specify 'does not render html' do
      get :find, name: 'Name'
      expect(response.status).to eq(406)
    end
    specify 'renders json' do
      get :find, name: 'Name', format: :json
      expect(response).to be_success
      expect(response.body).to eq(artists.to_json)
    end
  end
end

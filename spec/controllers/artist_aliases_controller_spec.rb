require 'spec_helper'

describe ArtistAliasesController do
  context '#GET index' do
    let!(:artist) { FactoryGirl.create(:artist) }
    let!(:aliases) { FactoryGirl.create_list(
      :artist_alias,
      3,
      artist: artist
    ) }
    specify 'assigns @aliases' do
      get :index, artist_id: artist.id
      expect(assigns(:aliases)).to match_array(artist.reload.aliases)
    end
    specify 'assigns @artist' do
      get :index, artist_id: artist.id
      expect(assigns(:artist)).to eq(artist)
    end
  end

  context '#POST create' do
    let!(:artist) { FactoryGirl.create(:artist) }
    specify 'assigns @name' do
      post :create, artist_id: artist.id, new_alias: 'name'
      expect(assigns(:name)).to eq('name')
    end
  end

end

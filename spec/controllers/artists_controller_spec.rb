require 'spec_helper'

describe ArtistsController do
  context 'GET #find' do
    let!(:artists) do
      a = FactoryGirl.create(:artist, name: 'Gary')
      b = FactoryGirl.create(:artist, name: 'Freddy')
      [a, b]
    end
    before do
      FactoryGirl.create(:artist_alias, name: 'Garie', artist: artists[0])
      FactoryGirl.create(:artist_alias, name: 'Gardner', artist: artists[1])
    end
    let!(:json) do
      Artist.
        joins(:aliases).
        where(["artist_aliases.name ILIKE ?", "%gar%"]).
        uniq.
        order('artists.id').
        limit(10).
        as_json(only: [:id], methods: [:name]).
        each(&:stringify_keys!)
    end
    specify 'assigns @artists' do
      get :find, name: 'Gar'
      expect(assigns(:json)).to eq(json)
    end
    specify 'does not render html' do
      get :find, name: 'Gar'
      expect(response.status).to eq(406)
    end
    specify 'renders json' do
      get :find, name: 'Gar', format: :json
      expect(response).to be_success
      expect(response.body).to eq(json.to_json)
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

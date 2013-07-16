require 'spec_helper'

describe Artist do
  context '#database attributes' do
  end
  context '#virtual attributes' do
    it { should respond_to(:name) }
  end
  context '#methods' do
    it { should respond_to(:merge) }
    it { should respond_to(:original) }
  end
  context '#associations' do
    it { should have_many(:aliases) }
    it { should have_many(:performances).through(:performance_artists) }
    it { should belong_to(:youtube_user) }
  end
  context '#validations' do
    it { should validate_uniqueness_of(:youtube_channel_id) }
    it { should validate_presence_of(:aliases) }
  end
  context '#methods' do
    describe '.add_alias' do
      specify 'creates an ArtistAlias record' do
        artist = FactoryGirl.create(:artist)
        expect(artist.aliases).to_not be_empty
      end
    end
    
    describe '.name' do
      specify 'returns the most proper alias' do
        artist = FactoryGirl.create(:artist, name: '2nd')
        most_proper_alias = FactoryGirl.create(
          :artist_alias, name: 'Most', artist: artist, proper: 101)
        expect(artist.reload.name).to eq('Most')
      end
    end
  end
end

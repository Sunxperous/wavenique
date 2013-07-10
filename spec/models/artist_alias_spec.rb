require 'spec_helper'

describe ArtistAlias do
  context '#database attributes' do
    it { should respond_to(:name) }
    it { should respond_to(:artist_id) }
    it { should respond_to(:proper) }
    #it { should respond_to(:language) }
  end
  context '#associations' do
    it { should belong_to(:artist) }
  end
  context '#validations' do
    it { should validate_presence_of(:name) }
    it { should allow_value('A' * 100).for(:name) }
    it { should_not allow_value('a' * 101).for(:name) }
  end
end

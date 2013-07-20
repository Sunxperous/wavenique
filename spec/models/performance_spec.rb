require 'spec_helper'

describe Performance do
  context '#methods' do
  end
  context '#associations' do
    it { should belong_to(:wave) }
    it { should have_many(:artists).through(:performance_artists) }
    it { should have_many(:compositions).through(:performance_compositions) }
    it { should have_many(:labels).through(:performance_labels) }
  end
  context '#validations' do
    it { should validate_presence_of(:wave) }
    it { should validate_presence_of(:compositions) }
  end
end

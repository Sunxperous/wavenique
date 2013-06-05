require 'spec_helper'

describe Performance do
  context '#methods' do
    it { should respond_to(:define) }
    it { should respond_to(:redefine) }
  end
  context '#associations' do
    it { should belong_to(:youtube) }
    it { should have_many(:artists).through(:performance_artists) }
    it { should have_many(:compositions).through(:performance_compositions) }
    it { should have_many(:tags).through(:performance_tags) }
  end
  context '#validations' do
    it { should validate_presence_of(:youtube) }
    it { should validate_presence_of(:compositions) }
  end
end

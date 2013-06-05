require 'spec_helper'

describe Artist do
  context '#database attributes' do
    it { should respond_to(:name) }
  end
  context '#methods' do
    it { should respond_to(:merge) }
    it { should respond_to(:original) }
  end
  context '#associations' do
    it { should have_many(:performances).through(:performance_artists) }
    it { should belong_to(:youtube_user) }
  end
  context '#validations' do
    it { should validate_uniqueness_of(:youtube_channel_id) }
    it { should validate_presence_of(:name) }
    it { should allow_value('Artist').for(:name) }
    it { should_not allow_value('a' * 101).for(:name) }
  end
end

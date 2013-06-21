require 'spec_helper'

describe Youtube do
  before do
    # Stub API-calling methods.
  end
  context '#database attributes' do
    it { should respond_to(:video_id) }
    it { should respond_to(:channel_id) }
  end
  context '#virtual attributes' do
    it { should respond_to(:new_content) }
    it { should respond_to(:warnings) }
  end
  context '#methods' do
    it { should respond_to(:related) }
    it { should respond_to(:modify) }
    it { should respond_to(:api_data) }
  end
  context '#associations' do
    it { should have_many(:performances) }
    it { should belong_to(:channel) }
  end
  context '#validations' do
    it { should validate_presence_of(:performances) }
    it { should validate_presence_of(:video_id) }
    # channel_id must be present, but user of that channel may not.
    it { should validate_presence_of(:channel_id) }
    it { should validate_uniqueness_of(:video_id) }
    it { should_not allow_value('qwerty_').for(:video_id) }
    it { should_not allow_value('qwertyqwerty').for(:video_id) }
    it { should_not allow_value('!@#$%^&*()+').for(:video_id) }
    it { should allow_value('Qwerty123_-').for(:video_id) }
  end
end

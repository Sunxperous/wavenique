require 'spec_helper'

describe Youtube do
  before do
    # Stub API-calling methods.
    Youtube.any_instance.stub(:fill_site_info)
    Youtube.any_instance.stub(:api_data) { OpenStruct.new(
      status: OpenStruct.new(
        embeddable: true,
        privacyStatus: 'public'
      ),
      snippet: OpenStruct.new(
        categoryId: '10'
      )
    ) }
  end
  context '#database attributes' do
    it { should respond_to(:video_id) }
    it { should respond_to(:channel_id) }
  end
  context '#virtual attributes' do
    it { should respond_to(:reference_id) }
  end
  context '#methods' do
    it { should respond_to(:related) }
    it { should respond_to(:api_data) }
    it { should respond_to(:clear_performances) }
    it { should respond_to(:music?) }
    it { should respond_to(:available?) }
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
  context '#methods' do
    describe '.available?' do
      specify 'stubbed values to return true' do
        expect(Youtube.new.available?).to eq(true)
      end
    end
    describe '.music?' do
      specify 'stubbed values to return true' do
        expect(Youtube.new.music?).to eq(true)
      end
    end
    describe '.clear_performances' do
      specify 'sets performance to empty array' do
        youtube = FactoryGirl.create(
          :youtube_with_perf,
          perf: [{ a: 1, c: 1 }]
        )
        youtube.clear_performances
        expect(youtube.performances).to eq([])
      end
    end
  end
end

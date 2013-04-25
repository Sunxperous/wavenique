require 'spec_helper'

describe Youtube do
	it { should have_many(:performances) }

	it { should respond_to(:video_id) }
	it { should validate_presence_of(:video_id) }
	it { should validate_uniqueness_of(:video_id) }
	it { should_not allow_value('qwerty').for(:video_id) }
	it { should_not allow_value('qwertyqwerty').for(:video_id) }
	it { should allow_value('qwerty12345').for(:video_id) }
end

require 'spec_helper'

describe User do
	let(:user) { User.new }
	subject { user }

	it { should respond_to(:google_id) }
	it { should validate_presence_of(:google_id) }
	it { should validate_uniqueness_of(:google_id) }

	it { should respond_to(:google_name) }
	it { should validate_presence_of(:google_name) }

	it { should respond_to(:google_refresh_token) }
	it { should validate_presence_of(:google_refresh_token) }

	it { should respond_to(:remember_token) }

	it { should respond_to(:playlists) }

	context 'class methods' do
		subject { User }
		it { should respond_to(:google_sign_in) }
	end
end

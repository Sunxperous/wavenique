require 'spec_helper'

describe User do
  before do
    # Stub API-calling methods.
    User.any_instance.stub(:fill_youtube_particulars) { true }
  end
  context '#database attributes' do
    it { should respond_to(:google_id) }
    it { should respond_to(:google_name) }
    it { should respond_to(:google_refresh_token) }
    it { should respond_to(:google_access_token) }
    it { should respond_to(:youtube_channel) }
    it { should respond_to(:remember_token) }
  end
  context '#methods' do
    it { should respond_to(:remember_token) }
    it { should respond_to(:fill_youtube_particulars) }
  end
  context '#associations' do
    it { should have_many(:youtube_uploads) }
    it { should have_one(:artist) }
  end
  context '#validations' do
    it { should validate_presence_of(:google_id) }
    it { should validate_presence_of(:google_name) }
    it { should validate_presence_of(:google_refresh_token) }
    it { should validate_presence_of(:google_access_token) }
    it { should validate_uniqueness_of(:google_id) }
  end

	context 'class methods' do
    describe '::google_sign_in' do
      specify 'response' do
        User.should respond_to(:google_sign_in)
      end
      let(:new_user) { FactoryGirl.build(:user) }
      before do
        # Stub API-calling methods.
        User.stub(:google_authentication) {
          [OpenStruct.new(id: new_user.google_id, name: new_user.google_name),
            new_user.google_access_token,
            new_user.google_refresh_token]
        }
      end
      context 'for a new user' do
        it 'changes User count' do
          expect { User.google_sign_in('code') }.to change(User, :count).by(1)
        end
        it 'returns a User object' do
          signed_in_user = User.google_sign_in('code')
          signed_in_user.google_id.should eq(new_user.google_id)
        end
      end
      context 'for an existing user' do
        before { new_user.save! }
        it 'does not change User Count' do
          expect { User.google_sign_in('code') }.not_to change(User, :count)
        end
        it 'returns the User object' do
          signed_in_user = User.google_sign_in('code')
          signed_in_user.should eq(new_user)
        end
      end
    end
	end
end

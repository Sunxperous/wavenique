require 'spec_helper'

describe User::Google do
  context '#database attributes' do
    it { should respond_to(:user_id) }
    it { should respond_to(:site_id) }
    it { should respond_to(:access_token) }
    it { should respond_to(:refresh_token) }
  end
  context '#associations' do
    it { should belong_to(:user) }
  end
  context '#validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:site_id) }
    it { should validate_presence_of(:access_token) }
    it { should validate_presence_of(:refresh_token) }
    it { should validate_uniqueness_of(:site_id) }
  end
  context '#methods' do
  end

  context '#class methods' do
    describe '.sign_in' do
      context 'for a new user' do
        let!(:new_ug) { FactoryGirl.build(:user_google) }
        before do
          GoogleAPI.stub(:authentication) { [
            OpenStruct.new( {
              'name' => new_ug.user.name,
              'id' => new_ug.site_id
            } ),
            'access_token',
            'refresh_token'
          ] }
        end
        subject { -> { User::Google.sign_in('code') } }
        it 'returns a User with a name' do
          user = subject.call
          expect(user.class).to eq(User)
          expect(user.name).to eq(new_ug.user.name)
        end
        it 'creates a User::Google record' do
          expect(subject).to change { User::Google.count }.by(1)
        end
        it 'creates a User record' do
          expect(subject).to change { User.count }.by(1)
        end
      end
      context 'for an existing user' do
        let!(:existing_ug) { FactoryGirl.create(:user_google) }
        before do
          GoogleAPI.stub(:authentication) { [
            OpenStruct.new( { 'id' => existing_ug.site_id } ),
            'access_token',
            'refresh_token'
          ] }
        end
        subject { -> { User::Google.sign_in('code') } }
        it 'does not create new User nor User::Google records' do
          expect(subject).to_not change { User::Google.count }
          expect(subject).to_not change { User.count }
        end
        it 'returns the existing User record' do
          user = subject.call
          expect(user).to eq(existing_ug.user)
        end
        it 'changes access and refresh token' do
          subject.call
          expect(existing_ug.reload.access_token).to eq('access_token')
          expect(existing_ug.reload.refresh_token).to eq('refresh_token')
        end
      end
    end
  end
end

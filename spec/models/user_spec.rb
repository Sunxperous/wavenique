require 'spec_helper'

describe User do
  before do
    # Stub API-calling methods.
  end
  context '#database attributes' do
    it { should respond_to(:name) }
    it { should respond_to(:remember_token) }
    it { should respond_to(:youtube) }
    it { should respond_to(:admin) }
  end
  context '#methods' do
    it { should respond_to(:remember_token) }
    it { should respond_to(:admin?) }
  end
  context '#associations' do
    it { should have_one(:youtube) }
  end
  context '#validations' do
  end
	context 'methods' do
	end
end

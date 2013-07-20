require 'spec_helper'

describe Label do
  context '#database attributes' do
    it { should respond_to(:name) }
  end
  context '#associations' do
    it { should have_many(:performance_labels) }
    it { should have_many(:performances).through(:performance_labels) }
  end
  context '#validations' do
    it { should validate_presence_of(:name) }
  end
end

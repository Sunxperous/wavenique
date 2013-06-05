require 'spec_helper'

describe Composition do
  context '#database attributes' do
    it { should respond_to(:title) }
  end
  context '#methods' do
    it { should respond_to(:merge) }
    it { should respond_to(:original) }
  end
  context '#associations' do
    it { should have_many(:performances).through(:performance_compositions) }
  end
  context '#validations' do
    it { should validate_presence_of(:title) }
    it { should allow_value('Composition').for(:title) }
    it { should_not allow_value('c' * 101).for(:title) }
  end
end

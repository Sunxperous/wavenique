require 'spec_helper'

describe PerformanceLabel do
  context '#associations' do
    it { should belong_to(:label) }
    it { should belong_to(:performance) }
  end
  context '#validations' do
    it { should validate_presence_of(:label) }
    it { should validate_presence_of(:performance) }
  end
end

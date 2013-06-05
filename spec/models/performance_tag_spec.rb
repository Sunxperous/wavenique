require 'spec_helper'

describe PerformanceTag do
  it { should belong_to(:tag) }
  it { should validate_presence_of(:tag) }

  it { should belong_to(:performance) }
  it { should validate_presence_of(:performance) }
end

require 'spec_helper'

describe PerformanceArtist do
  it { should belong_to(:performance) }
  it { should validate_presence_of(:performance) }

  it { should belong_to(:artist) }
  it { should validate_presence_of(:artist) }
end

require 'spec_helper'

describe Artist do
  it { should have_many(:names) }
  it { should have_many(:performances).through(:performance_artists) }
end

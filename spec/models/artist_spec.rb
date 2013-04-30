require 'spec_helper'

describe Artist do
	it { should respond_to(:name) }
	it { should validate_presence_of(:name) }

  it { should have_many(:performances).through(:performance_artists) }
end

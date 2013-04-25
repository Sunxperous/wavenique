require 'spec_helper'

describe Performance do
	it { should belong_to(:youtube) }

	it { should have_many(:artists).through(:performance_artists) }
	it { should have_many(:compositions).through(:performance_compositions) }
end

require 'spec_helper'

describe PerformanceComposition do
	it { should belong_to(:performance) }
	it { should validate_presence_of(:performance) }

	it { should belong_to(:composition) }
	it { should validate_presence_of(:composition) }
end

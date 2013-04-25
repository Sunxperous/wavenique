require 'spec_helper'

describe Composition do
	it { should have_many(:titles) }
	
	it { should have_many(:performances).through(:performance_compositions) }
end

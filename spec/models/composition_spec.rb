require 'spec_helper'

describe Composition do
	it { should respond_to(:title) }
	it { should validate_presence_of(:title) }

	it { should have_many(:performances).through(:performance_compositions) }
end

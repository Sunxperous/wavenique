require 'spec_helper'

describe Title do
	it { should respond_to(:title) }
	it { should validate_presence_of(:title) }

	it { should belong_to(:composition) }
end

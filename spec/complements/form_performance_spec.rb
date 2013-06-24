require 'spec_helper'

describe Form::Performance do
  context '#virtual attributes' do
    it { should respond_to(:performances) }
    it { should respond_to(:wave_info) }
    it { should respond_to(:new_content) }
  end
end

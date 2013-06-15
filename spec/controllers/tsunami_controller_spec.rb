require 'spec_helper'

describe TsunamiController do
  context 'GET #index' do
    include_examples 'accessible by admins only' do
      let(:action) { -> { get :index } }
    end
  end
end

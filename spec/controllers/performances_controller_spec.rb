require 'spec_helper'

describe PerformancesController do
  specify 'renders errors for non-existing wave types' do
    put :modify, type: 'asd', id: 'asd'
    expect(response.status).to eq(404)
  end
  context 'PUT #modify' do
    specify 'assigns @form_performance' do
      Form::Performance.any_instance.stub(:process)
      put :modify, type: 'youtube', id: 'qwertyuiop-', p: 'present'
      expect(assigns[:form_performance]).to_not eq(nil)
    end
  end
end

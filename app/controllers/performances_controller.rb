class PerformancesController < ApplicationController
  def modify
    @form_performance = Form::Performance.new(params)
    render nothing: true
  end
end

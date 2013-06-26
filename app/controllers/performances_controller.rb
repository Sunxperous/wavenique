class PerformancesController < ApplicationController
  before_filter :valid_wave_type
  def modify
    @form_performance = Form::Performance.new(params)
    @form_performance.process
    render nothing: true
  end

  private
  def valid_wave_type
    render nothing: true, status: 404 if params[:type] != 'youtube'
  end
end

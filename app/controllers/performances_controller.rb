class PerformancesController < ApplicationController
  before_filter :valid_wave_type
  def modify
    @form_performance = Form::Performance.new(params)
    result = @form_performance.process
    @wave = @form_performance.wave if result
    respond_to do |format|
      #format.html { redirect_to youtube_path(@form_performance.wave) }
      format.js { render 'result' if result }
    end
  end

  private
  def valid_wave_type
    render nothing: true, status: 404 if params[:type] != 'youtube'
  end
end

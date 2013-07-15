module WaveHelper
  def performance_form_for(wave, form_performance)
    if form_performance.present?
      count = Hash.new 0
      render 'performances/form', count: count, wave: wave
    end
  end
end

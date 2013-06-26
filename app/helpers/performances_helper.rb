module PerformancesHelper
	def form_performance_template
		form_performance = Form::Performance.new wave: Youtube.new
		render 'performances/form_performance',
			count: Hash.new(-1),
			performance: form_performance.wave.performances[0]
	end
end

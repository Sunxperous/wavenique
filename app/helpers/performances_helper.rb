module PerformancesHelper
	def form_performance_template
		form_performance = Form::Performance.new
		render 'performances/form_performance',
			count: Hash.new(-1),
			performance: form_performance.performances[0]
	end
end

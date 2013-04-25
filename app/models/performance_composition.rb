class PerformanceComposition < ActiveRecord::Base
	belongs_to :performance
	belongs_to :composition

	validates_presence_of :performance, :composition
end

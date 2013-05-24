class PerformanceComposition < ActiveRecord::Base
	belongs_to :performance
	belongs_to :composition, touch: true

	validates_presence_of :performance, :composition
end

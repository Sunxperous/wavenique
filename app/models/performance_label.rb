class PerformanceLabel < ActiveRecord::Base
  belongs_to :label
  belongs_to :performance, touch: true

  validates_presence_of :label, :performance
end

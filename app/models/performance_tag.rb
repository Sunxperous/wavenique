class PerformanceTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :performance, touch: true

  validates_presence_of :tag, :performance
end

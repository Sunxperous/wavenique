class Tag < ActiveRecord::Base
  attr_accessible :name

  has_many :performance_tags
  has_many :performances, through: :performance_tags
end

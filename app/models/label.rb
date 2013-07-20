class Label < ActiveRecord::Base
  attr_accessible :name

  has_many :performance_labels
  has_many :performances, through: :performance_labels

  validates :name, presence: true
end

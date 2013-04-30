class Composition < ActiveRecord::Base
	attr_accessible :title

	validates :title, presence: true

	has_many :performance_compositions
	has_many :performances, through: :performance_compositions

end

class Artist < ActiveRecord::Base
	attr_accessible :name

	validates :name, presence: true

	has_many :performance_artists
	has_many :performances, through: :performance_artists

end

class Artist < ActiveRecord::Base
	audited
	attr_accessible :name

	validates :name, presence: true, length: { maximum: 100 }

	has_many :performance_artists
	has_many :performances, through: :performance_artists

	def self.existing_or_new(id, name)
		name.present? ? self.where(id: id).first_or_initialize(name: name) : []
	end

end

class Artist < ActiveRecord::Base
	audited
	attr_accessible :name

	validates :name, presence: true

	has_many :performance_artists
	has_many :performances, through: :performance_artists

	def self.existing_or_new(id, name)
		name.present? ? self.where(id: id).first_or_initialize(name: name) : nil
	end

end

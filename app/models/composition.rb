class Composition < ActiveRecord::Base
	audited

	attr_accessible :title

	validates :title, presence: true

	has_many :performance_compositions
	has_many :performances, through: :performance_compositions

	def self.existing_or_new(id, title)
		title.present? ? self.where(id: id).first_or_initialize(title: title) : []
	end
end

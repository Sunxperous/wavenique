class Performance < ActiveRecord::Base
	belongs_to :youtube
	validates_presence_of :youtube
	has_many :performance_compositions
	has_many :compositions, through: :performance_compositions
	validates_associated :compositions
	has_many :performance_artists
	has_many :artists, through: :performance_artists
	validates_associated :artists
	before_save :link

	def define(compositions_hash, artists_hash)
		compositions_hash.each do |key, properties|
			if properties['t'].present?
				compositions << Composition.where(id: properties['id']).first_or_initialize(title: properties['t'])
			end
		end

		artists_hash.each do |key, properties|
			if properties['n'].present?
				artists << Artist.where(id: properties['id']).first_or_initialize(name: properties['n'])
			end
		end
	end

	def unlink
		update_attribute(:unlinked, true)
	end

	private
	def link
		self.unlinked ||= false
		true
	end
end

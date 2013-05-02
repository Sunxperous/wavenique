class Performance < ActiveRecord::Base
	audited associated_with: :youtube
	has_associated_audits
	belongs_to :youtube, touch: true
	validates_presence_of :youtube
	has_many :performance_compositions
	has_many :compositions, through: :performance_compositions
	validates_associated :compositions
	has_many :performance_artists
	has_many :artists, through: :performance_artists
	validates_associated :artists
	before_save :link

	def self.define_new(hash)
		perf = Performance.new
		hash['comp'].values.each do |properties|
			perf.compositions << Composition.existing_or_new(properties['id'], properties['t'])
		end
		hash['artist'].values.each do |properties|
			perf.artists << Artist.existing_or_new(properties['id'], properties['n'])
		end
		(perf.compositions.blank? and perf.artists.blank?) ? nil : perf				
	end

	def redefine(hash)
		compositions.delete_all
		artists.delete_all
		hash['comp'].values.each do |properties|
			compositions << Composition.existing_or_new(properties['id'], properties['t'])
		end
		hash['artist'].values.each do |properties|
			artists << Artist.existing_or_new(properties['id'], properties['n'])
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

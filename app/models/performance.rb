class Performance < ActiveRecord::Base
	audited associated_with: :youtube
	has_associated_audits
	belongs_to :youtube, touch: true, inverse_of: :performances
	validates_presence_of :youtube
	has_many :performance_compositions
	has_many :compositions, through: :performance_compositions
  validates_presence_of :compositions
	validates_associated :compositions
	has_many :performance_artists
	has_many :artists, through: :performance_artists
	validates_associated :artists
	before_save :link

  def define(incoming, new_content)
		incoming['comp'].values.each do |properties|
			compositions << Composition.existing_or_new(
        properties['id'], properties['t'], new_content)
		end
		incoming['artist'].values.each do |properties|
			artists << Artist.existing_or_new(
        properties['id'], properties['n'], new_content)
		end
  end

	def self.define_new(incoming, new_content)
		perf = Performance.new
    perf.define(incoming, new_content)
		(perf.compositions.blank? and perf.artists.blank?) ? [] : perf
	end

	def redefine(incoming, new_content)
		compositions.clear
		artists.clear
    define(incoming, new_content)
		unlink if (compositions.blank? and artists.blank?)
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

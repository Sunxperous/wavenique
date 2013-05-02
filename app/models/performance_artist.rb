class PerformanceArtist < ActiveRecord::Base
	audited associated_with: :performance
	belongs_to :artist
	belongs_to :performance, touch: true

	validates_presence_of :artist, :performance
end

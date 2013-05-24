class PerformanceArtist < ActiveRecord::Base
	belongs_to :artist
	belongs_to :performance, touch: true

	validates_presence_of :artist, :performance
end

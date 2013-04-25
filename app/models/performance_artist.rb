class PerformanceArtist < ActiveRecord::Base
	belongs_to :artist
	belongs_to :performance

	validates_presence_of :artist, :performance
end

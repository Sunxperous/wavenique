class Performance < ActiveRecord::Base
	belongs_to :youtube
	has_many :performance_compositions
	has_many :compositions, through: :performance_compositions
	has_many :performance_artists
	has_many :artists, through: :performance_artists

	def define(titles, names)
		titles.each do |key, properties|
			if properties['t'].present?
				composition = Composition.existing_or_new_title(properties['c_id'], properties['t'])
				compositions << composition unless composition.titles.empty?
			end
		end

		names.each do |key, properties|
			if properties['n'].present?
				artist = Artist.existing_or_new_name(properties['a_id'], properties['n'])
				artists << artist unless artist.names.empty?
			end
		end
	end
end

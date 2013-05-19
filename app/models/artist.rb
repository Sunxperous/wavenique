class Artist < ActiveRecord::Base
	audited
	attr_accessible :name

	validates :name, presence: true, length: { maximum: 100 }

	has_many :performance_artists
	has_many :performances, through: :performance_artists

	def self.existing_or_new(id, name, new_content)
    # Return empty array on missing name.
    return [] unless name.present?
    artist = self.where(id: id).first_or_initialize(name: name)
    # Return an existing artist from the database.
    return artist unless artist.new_record? 
    recent = new_content[:artists].select { |n| n.name == artist.name }.last
    # Return recent incoming, non-existent artist.
    return recent if recent.present?
    new_content[:artists] << artist
    # Return an entirely new artist.
    artist
	end

end

class Artist < ActiveRecord::Base
	attr_accessible :name
	has_many :performance_artists
	has_many :performances, through: :performance_artists
	validates :name, presence: true, length: { maximum: 100 }

	def self.existing_or_new(id, name, new_content)
    # Return empty array on missing name.
    return [] unless name.present?
    artist = self.where(id: id).first_or_initialize(name: name)
    # Return the original artist from the database.
    return Artist.find(artist.original) unless artist.new_record? 
    recent = new_content[:artists].select { |n| n.name == artist.name }.last
    # Return recent incoming, non-existent artist.
    return recent if recent.present?
    new_content[:artists] << artist
    # Return an entirely new artist.
    artist
	end

  def merge(target)
    update_attribute(:original_id, target)
    PerformanceArtist.where("artist_id = ?", id).update_all(:artist_id => target)
    Artist.where("original_id = ?", id).update_all(:original_id => target)
  end

  def original
    self.original_id or self.id
  end
end

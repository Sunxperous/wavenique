class Artist < ActiveRecord::Base
	attr_accessible :name
	has_many :performance_artists
	has_many :performances, through: :performance_artists
  belongs_to :youtube_user, class_name: 'User', primary_key: 'youtube_channel', foreign_key: 'youtube_channel_id'
  validates :youtube_channel_id, uniqueness: true, allow_nil: true
	validates :name, presence: true, length: { maximum: 100 }

	def self.existing_or_new(properties, new_content)
    # Return empty array on missing name.
    return [] unless properties['n'].present?
    if properties['u'].present?
      artist = self.where(youtube_channel_id: properties['u']).
        first_or_initialize(name: properties['n'])
      artist.youtube_channel_id = properties['u']
    else
      artist = self.where(id: properties['id']).
        first_or_initialize(name: properties['n'])
    end
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

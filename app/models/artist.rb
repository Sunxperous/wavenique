class Artist < ActiveRecord::Base
	attr_accessible :name
	has_many :performance_artists
	has_many :performances, through: :performance_artists
  belongs_to :youtube_user, class_name: 'User', primary_key: 'youtube_channel', foreign_key: 'youtube_channel_id'
  validates :youtube_channel_id, uniqueness: true, allow_nil: true
	validates :name, presence: true, length: { maximum: 100 }

  def merge(target)
    update_attribute(:original_id, target)
    PerformanceArtist.where("artist_id = ?", id).update_all(:artist_id => target)
    Artist.where("original_id = ?", id).update_all(:original_id => target)
  end

  def original
    self.original_id or self.id
  end
end

class Artist < ActiveRecord::Base
  attr_accessible :name
  attr_writer :name
	has_many :performance_artists
	has_many :performances, through: :performance_artists
  has_many :aliases, class_name: 'ArtistAlias'
  belongs_to :youtube_user, class_name: 'User', primary_key: 'youtube_channel', foreign_key: 'youtube_channel_id'
  validates :youtube_channel_id, uniqueness: true, allow_nil: true
  validates :aliases, presence: true
  validates_associated :aliases
  before_validation :add_alias, on: :create

  def merge(target)
    update_attribute(:original_id, target)
    PerformanceArtist.where("artist_id = ?", id).update_all(:artist_id => target)
    Artist.where("original_id = ?", id).update_all(:original_id => target)
  end

  def original
    self.original_id or self.id
  end

  def name
    return aliases.order('proper DESC').first.name if aliases.present?
    @name ||= ''
  end

  private
  def add_alias
    if @name.present? and aliases.empty?
      artist_alias = ArtistAlias.new(name: name)
      artist_alias.proper = true
      aliases << artist_alias
    end
  end
end

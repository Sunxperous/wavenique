class ArtistAlias < ActiveRecord::Base
  attr_accessible :name
  validates :name, length: { maximum: 100 }, presence: true

  belongs_to :artist
end

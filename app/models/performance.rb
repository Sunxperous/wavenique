class Performance < ActiveRecord::Base
	belongs_to :wave, polymorphic: true, touch: true, inverse_of: :performances
	has_many :performance_compositions
	has_many :compositions, through: :performance_compositions
	has_many :performance_artists
	has_many :artists, through: :performance_artists
  has_many :performance_labels
  has_many :labels, through: :performance_labels
	validates_presence_of :wave, :compositions
	validates_associated :compositions, :artists
end

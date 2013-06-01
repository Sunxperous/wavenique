class Performance < ActiveRecord::Base
	belongs_to :youtube, touch: true, inverse_of: :performances
	has_many :performance_compositions
	has_many :compositions, through: :performance_compositions
	has_many :performance_artists
	has_many :artists, through: :performance_artists
	validates_presence_of :youtube, :compositions
	validates_associated :compositions, :artists

  def define(incoming, new_content)
		incoming['comp'].values.each do |properties|
			compositions << Composition.existing_or_new(
        properties['id'], properties['t'], new_content)
		end
		incoming['artist'].values.each do |properties|
			artists << Artist.existing_or_new(properties, new_content)
		end
  end

	def self.define_new(incoming, new_content)
		perf = Performance.new
    perf.define(incoming, new_content)
		(perf.compositions.blank? and perf.artists.blank?) ? [] : perf
	end

	def redefine(incoming, new_content)
		compositions.clear
		artists.clear
    define(incoming, new_content)
	end

	private
end

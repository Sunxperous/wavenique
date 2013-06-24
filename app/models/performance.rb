class Performance < ActiveRecord::Base
	belongs_to :wave, polymorphic: true, touch: true, inverse_of: :performances
	has_many :performance_compositions
	has_many :compositions, through: :performance_compositions
	has_many :performance_artists
	has_many :artists, through: :performance_artists
  has_many :performance_tags
  has_many :tags, through: :performance_tags
	validates_presence_of :wave, :compositions
	validates_associated :compositions, :artists

  def define(incoming, new_content)
		incoming['c'].values.each do |properties|
			compositions << Composition.existing_or_new(
        properties['id'], properties['t'], new_content)
		end
		incoming['a'].values.each do |properties|
			artists << Artist.existing_or_new(properties, new_content)
		end
    if incoming['t'].present?
      incoming['t'].each do |name|
        tags << Tag.find_by_name(name)
      end
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
    tags.clear
    define(incoming, new_content)
	end
end

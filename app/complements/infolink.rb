class Infolink
  attr_accessor :title, :wave

  def self.artist(artist, options = { count: 10 })
    performances = Performance.
      where("deleted_at IS NULL").
      joins(performance_artists: :artist).
      where(artists: { id: artist.id }).
      order("created_at DESC").
      limit(options[:count]).
      includes(:compositions, :artists, :wave => :performances)
    performances.map do |performance|
      infolink = Infolink.new
      infolink.title = performance.compositions.map(&:title).join(', ')
      infolink.wave = performance.wave
      infolink
    end
  end

  def self.composition(composition, options = { count: 10 })
    performances = Performance.
      where("deleted_at IS NULL").
      joins(performance_compositions: :composition).
      where(compositions: { id: composition.id }).
      order("created_at DESC").
      limit(options[:count]).
      includes(:compositions, :artists, :wave => :performances)
    performances.map do |performance|
      infolink = Infolink.new
      infolink.title = performance.artists.map(&:name).join(', ')
      infolink.wave = performance.wave
      infolink
    end
  end
end

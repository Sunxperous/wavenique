# p: Performance
#   a: Artist
#     n: Name
#   c: Composition
#     t: Title

class Form::Performance
  attr_accessor :wave, :new_content, :incoming, :errors

  def initialize(params = { })
    self.errors = { }
    if params[:wave].present? # Wave was passed in.
      self.wave = params[:wave]
      wave.performances << default_performance if wave.performances.empty?
    elsif params[:p].present? # Parameters were passed in.
      self.incoming = params
      self.wave = instantiate_wave incoming[:type], incoming[:id]
    end
  end

  def process
    if !wave.new_record?
      return false if conflicted?
      return false if !changes?
    end
    cleanse_incoming_nils
    wave.transaction do
      assign_performances(incoming[:p])
      wave.save
    end
  end

  private
  def changes?
    incoming_c = incoming[:p].values.map do |p|
      p[:c].map { |c_k, c_v| c_v[:id].blank? ? c_v[:t] : c_v[:id].to_i }
    end
    incoming_a = incoming[:p].values.map do |p|
      p[:a].map { |a_k, a_v| a_v[:id].blank? ? a_v[:n] : a_v[:id].to_i }
    end
    current_c = wave.performances.map { |p| p.composition_ids }
    current_a = wave.performances.map { |p| p.artist_ids }
    result = incoming_c != current_c or incoming_a != current_a
    errors[:no_changes] = "There are no changes made." unless result
    result
  end

  def conflicted?
    result = incoming[:timestamp] != wave.updated_at.to_s
    errors[:conflicted] = "Someone else has modified this wave." if result
    result
  end
  
  def assign_performances(incoming_performances)
    self.new_content = { a: [], c: [] }
    wave.transaction do
      wave.clear_performances unless wave.new_record?
      incoming_performances.each do |p_k, p_v|
        wave.performances << define_performance(p_v)
      end
      raise ActiveRecord::Rollback unless wave.valid?
    end
  end

  def define_performance(incoming_values)
    p = Performance.new
		incoming_values[:c].each do |p_k, p_v|
			p.compositions << define_composition(p_v[:id], p_v[:t])
		end
		incoming_values[:a].each do |p_k, p_v|
			p.artists << define_artist(p_v[:id], p_v[:n])
		end
    p
  end

  def define_composition(id, title)
    # Return empty array on missing title.
    return [] unless title.present?
    c = Composition.where(id: id).first_or_initialize(title: title)
    # Return an existing composition from the database.
    return Composition.find(c.original) unless c.new_record?
    recent = new_content[:c].select { |n| n.title == c.title }.last
    # Return recent incoming, non-existent composition.
    return recent if recent.present?
    new_content[:c] << c
    # Return an entirely new composition.
    c
  end

  def define_artist(id, name)
    # Return empty array on missing name.
    return [] unless name.present?
    a = Artist.where(id: id).first_or_initialize(name: name)
    # Return the original artist from the database.
    return Artist.find(a.original) unless a.new_record? 
    recent = new_content[:a].select { |n| n.name == a.name }.last
    # Return recent incoming, non-existent artist.
    return recent if recent.present?
    new_content[:a] << a
    # Return an entirely new artist.
    a
	end

  def instantiate_wave(type, id)
    case type
    when 'youtube'
      Youtube.where(video_id: id).first_or_initialize(video_id: id)
    end
  end

  def cleanse_incoming_nils
    incoming[:p].delete_if do |p_k, p_v|
      p_v[:c].delete_if { |c_k, c_v| c_v['t'].blank? }
      p_v[:a].delete_if { |a_k, a_v| a_v['n'].blank? }
      p_v[:c].empty?
    end
  end

  def default_performance
    performance = Performance.new
    performance.artists.build
    performance.compositions.build
    performance
  end
end

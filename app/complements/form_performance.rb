# p: Performance
#   a: Artist
#     n: Name
#   c: Composition
#     t: Title

class Form::Performance
  attr_accessor :performances, :wave_info, :new_content

  def initialize(incoming = nil)
    self.performances = []
    if incoming.nil?
      self.performances << default_performance
    else
      cleanse incoming[:p]
      self.wave_info = incoming[:wave] || { }
      self.wave_info[:type] = incoming[:type]
      self.wave_info[:id] = incoming[:id]
      assign_performances(incoming[:p])
    end
  end

  def assign_performances(incoming_performances)
    self.new_content = { a: [], c: [] }
    wave.transaction do
      incoming_performances.each do |p_k, p_v|
        wave.performances << Performance.define_new(p_v, self.new_content)
      end
      raise ActiveRecord::Rollback unless wave.valid?
      wave.save
    end
  end

  private
  def cleanse(incoming_performances)
    incoming_performances.delete_if do |p_k, p_v|
      p_v[:c].delete_if { |c_k, c_v| c_v['t'].blank? }
      p_v[:a].delete_if { |a_k, a_v| a_v['n'].blank? }
      p_v[:c].empty?
    end
  end
  def default_performance
    performance = HashWithIndifferentAccess.new
    performance[:a] = [ { n: '' } ]
    performance[:c] = [ { t: '' } ]
    performance
  end
  def wave
    case self.wave_info[:type]
    when 'youtube'
      @wave ||= Youtube.new(video_id: self.wave_info[:id])
    end
  end
end

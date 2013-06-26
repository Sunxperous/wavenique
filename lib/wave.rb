module Wave
  def wave_to_hash
    hash = HashWithIndifferentAccess.new(
      type: self.class.to_s.downcase,
      id: reference_id,
      timestamp: updated_at.to_s,
      p: { }
    )
    index = Hash.new 0
    performances.each do |p|
      p_hash = { c: { }, a: { } }
      p.artists.each do |a|
        p_hash[:a][index[:a] += 1] = { n: a.name, id: a.id }
      end
      p.compositions.each do |c|
        p_hash[:c][index[:c] += 1] = { t: c.title, id: c.id }
      end
      hash[:p][index[:p] += 1] = p_hash
    end
    hash
  end
end

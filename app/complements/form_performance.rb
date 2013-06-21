# p: Performance
#   a: Artist
#     n: Name
#   c: Composition
#     t: Title

class Form::Performance
  attr_accessor :performances

  def initialize
    self.performances = []
    self.performances << default_performance
  end

  def default_performance
    performance = HashWithIndifferentAccess.new
    performance[:a] = [ { n: '' } ]
    performance[:c] = [ { t: '' } ]
    performance
  end
end

class Form
end

class Form::Performance
  attr_accessor :performances

  def initialize
    self.performances = HashWithIndifferentAccess.new
    self.performances[:artists] = { }
    self.performance[:compositions] = { }
  end
end

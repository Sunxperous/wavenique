class Composition < ActiveRecord::Base
	has_many :titles
	has_many :performance_compositions
	has_many :performances, through: :performance_compositions

	def self.existing_or_new_title(c_id, title)
		c = Composition.where(id: c_id).first
		if c.nil?
			c = Composition.new
			c.new_title(title)
		end
		c
	end

	def new_title(title)
		t = titles.build(title: title)
		if !t.valid?
			titles.delete(t)
			return false
		elsif !self.new_record?
			t.save
		end
		t
	end
end

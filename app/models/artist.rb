class Artist < ActiveRecord::Base
	has_many :names
	has_many :performance_artists
	has_many :performances, through: :performance_artists

	def self.existing_or_new_name(a_id, name)
		a = Artist.where(id: a_id).first
		if a.nil?
			a = Artist.new
			a.new_name(name)
		end
		a
	end

	def new_name(name)
		n = names.build(name: name)
		if !n.valid?
			names.delete(n)
			return false
		elsif !self.new_record?
			n.save
		end
		n
	end
end

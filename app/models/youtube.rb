class Youtube < ActiveRecord::Base
	audited
	has_associated_audits
	attr_accessible :video_id
	has_many :performances, inverse_of: :youtube, conditions: { unlinked: false }

	validates :video_id, length: { is: 11 }, presence: true, uniqueness: { case_sensitive: true }
	validates_presence_of :performances
	validates_associated :performances

	def modify(p)
		# Validate video_id is embeddable and in Music category. And exists.
		if !new_record?
		 	if p[:timestamp] == associated_audits.last.created_at.to_s
				edit_performances(p[:perf])
			else
				#errors[:base] << "#{p[:timestamp]} is not the same as #{associated_audits.last.created_at}."
				return false
			end
		else
			add_performances(p[:perf])
		end
		save
	end

	private
	def add_performances(performances_hash)
		performances_hash.values.each do |hash|
			performances << Performance.define_new(hash)
		end
	end

	def edit_performances(performances_hash)
		current_performances = performances.all
		if current_performances.length >= performances_hash.length # If there are more or equal existing performances...
			current_performances.zip(performances_hash.values) do |current, new|
				new.present? ? current.redefine(new) : current.unlink
			end
		else # There are less existing performances...
			performances_hash.values.zip(current_performances) do |new, current|
				if current.present?
					current.redefine(new)
				else
					performances << Performance.define_new(new)
				end
			end
		end
	end
end



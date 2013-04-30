class Youtube < ActiveRecord::Base
	attr_accessible :video_id
	has_many :performances, inverse_of: :youtube, conditions: { unlinked: false }

	validates :video_id, length: { is: 11 }, presence: true, uniqueness: { case_sensitive: true }
	validates_presence_of :performances
	validates_associated :performances

	def modify(p)
		# Validate video_id is embeddable and in Music category. And exists.
		unlink_performances unless self.new_record?
		add_performances(p[:perf])
		save
	end

	private
	def add_performances(performances_hash)
		performances_hash.each do |key, hash|
			performance = self.performances.build
			performance.define(hash['comp'], hash['artist'])
			if performance.compositions.blank? and performance.artists.blank?
				performances.delete(performance)
			end
		end
	end

	def unlink_performances
		performances.each do |performance|
			performance.unlink
		end
	end
end



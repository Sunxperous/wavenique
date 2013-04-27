class Youtube < ActiveRecord::Base
	attr_accessible :video_id
	has_many :performances

	validates :video_id, length: { is: 11 }, presence: true, uniqueness: { case_sensitive: true }
	validates_presence_of :performances

	def modify(p)
		# Validate video_id is embeddable and in Music category. And exists.
		# unlink_performances?
		add_performances(p[:perf])
		save
	end

	private
	def add_performances(perfs)
		perfs.each do |p_perf_k, p_perf_v|
			perf = self.performances.build
			perf.define(p_perf_v['titles'], p_perf_v['names'])
			if perf.compositions.blank? and perf.artists.blank?
				performances.delete(perf)
			end
		end
	end
end


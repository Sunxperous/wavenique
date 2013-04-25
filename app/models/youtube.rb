class Youtube < ActiveRecord::Base
	attr_accessible :video_id
	has_many :performances

	validates :video_id, length: { is: 11 }, presence: true, uniqueness: { case_sensitive: true }

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
=begin
			p_perf_v['titles'].each do |p_title_k, p_title_v|
				if p_title_v['c_id'].present? and Composition.exists?(p_title_v['c_id'])
					perf.compositions << Composition.find(p_title_v['c_id'])
				else
					composition = perf.compositions.build
					new_title = composition.titles.build(title: p_title_v['t'])
					if !new_title.valid?
						perf.compositions.delete(composition)
					end
				end
			end
			p_perf_v['names'].each do |p_name_k, p_name_v|
				if p_name_v['a_id'].present? and Artist.exists?(p_name_v['a_id'])
					perf.artists << Artist.find(p_name_v['a_id'])
				else
					artist = perf.artists.build
					new_name = artist.names.build(name: p_name_v['t'])
					if !new_name.valid?
						perf.artists.delete(artist)
					end
				end
			end
=end
			if perf.compositions.blank? and perf.artists.blank?
				youtube.performances.delete(perf)
			end
		end
	end
end


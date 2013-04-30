module YoutubeHelper
	def iframe_embed(video_id)
		src = "http://www.youtube.com/embed/#{video_id}?enablejsapi=1&origin=http://localhost:3000"
		iframe_tag = "<iframe id=\"player\" type=\"text/html\" width=\"640\" height=\"390\" src=\"#{src}\" frameborder=\"0\"></iframe>"
	end

	def single_performance_template
		p = Performance.new
		p.compositions.build
		p.artists.build
		p
	end

end

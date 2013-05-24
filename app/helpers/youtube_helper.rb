module YoutubeHelper
	def iframe_embed(video_id)
    src = "http://www.youtube.com/embed/#{video_id}?&origin=http://localhost:3000"
    iframe_tag = '<iframe id="player" type="text/html" width="640" height="390" src="' + src + '" frameborder="0"></iframe>'
	end

	def single_performance_template
		p = Performance.new
		p.compositions.build
		p.artists.build
		render 'form_performance',
			count: Hash.new(-1),
			fieldset_class: 'hidden',
			performance: p
	end

  def add_edit_link_for(youtube)
  	link_to_if youtube.new_record?,
      'Add', new_youtube_path(youtube), remote: true do # Else...
      link_to 'Edit', edit_youtube_path(youtube), remote: true
		end
  end
end

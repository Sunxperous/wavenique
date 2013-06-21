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

  def thumbnail_for(video_id)
    "https://i.ytimg.com/vi/#{video_id}/default.jpg"
  end
  
  def video_link_for(video_id)
    "https://www.youtube.com/watch?v=#{video_id}"
  end

  def channel_link_for(channel_id)
    "https://www.youtube.com/channel/#{channel_id}"
  end

  def generate_infolink(details={})
    # focus: whether Youtube, artist, composition.
    if details[:focus] == "composition"
      primary = details[:performance].compositions.map(&:title).join(', ')
      if details[:performance].artists.length > 1
        with = details[:performance].artists.map(&:name).join(', ')
      end
    elsif details[:focus] == "artist"
      primary = details[:performance].artists.map(&:name).join(', ')
      if details[:performance].compositions.length > 1
        with = details[:performance].compositions.map(&:title).join(', ')
      end
    else
      # details[:focus] = Youtube.
    end
    if details[:performance].youtube.performances.count > 1
      count = details[:performance].youtube.performances.count
      additional = "#{count - 1} other #{'performance'.pluralize(count - 1)}"
    end
    render 'youtube/infolink',
      video_id: details[:performance].youtube.video_id,
      primary: primary,
      tags: details[:performance].tags.map(&:name).join(' '),
      with: with,
      additional: additional
  end
end

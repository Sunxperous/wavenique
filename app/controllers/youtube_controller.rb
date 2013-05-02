class YoutubeController < ApplicationController
	def show
		client = GoogleAPI.client
		# Use a begin..catch block for Google API client executions.
		youtube_api = client.discovered_api('youtube', 'v3')
		result = client.execute(
			api_method: youtube_api.videos.list,
			parameters: {
				id: params[:video_id],
				part: 'snippet,status',
				fields: 'items(id,status(embeddable),snippet(title,categoryId,channelId,channelTitle))'
			}
		)
		@data = result.data
		if @youtube = Youtube.find_by_video_id(params[:video_id])
			# Existing Wavenique data for video.
			@performances = @youtube.performances
		else
			@youtube = Youtube.new(video_id: params[:video_id])
			p = @youtube.performances.build
			p.compositions.build
			p.artists.build
		end
	end

	def create
		@youtube = Youtube.new(video_id: params[:video_id])
		@youtube.modify(params) ? (render 'success') : (render 'errors')
	end

	def update
		@youtube = Youtube.find_by_video_id(params[:video_id])
		@youtube.modify(params) ? (render 'success') : (render 'errors')
	end
end

class YoutubeController < ApplicationController
	# :id parameter always refers to :video_id column.
	def new
		@youtube = Youtube.new(video_id: params[:id])
		p = @youtube.performances.build
		p.compositions.build
		p.artists.build
		respond_to do |format|
			format.html { redirect_to youtube_path(@youtube) }
			format.js { render 'append_form' }
		end
	end

	def edit
		@youtube = Youtube.find_by_video_id(params[:id])
		respond_to do |format|
			format.html { redirect_to youtube_path(@youtube) }
			format.js { render 'append_form' }
		end
	end

	def show
		@youtube = Youtube.find_by_video_id(params[:id]) || Youtube.new(video_id: params[:id])
		client = GoogleAPI.new_client
		# Use a begin..catch block for Google API client executions.
    # Especially for users who revoked access.
		youtube_api = client.discovered_api('youtube', 'v3')
		result = client.execute(
			api_method: youtube_api.videos.list,
			parameters: {
				id: params[:id],
				part: 'snippet,status',
				fields: 'items(status(embeddable,privacyStatus),snippet(title,categoryId,channelId,channelTitle))'
			}
			# Parameters to be different for cached video data.
		)
    @youtube.api_data = result.data.items[0]
    @warnings = []
    if @youtube.api_data.snippet.categoryId != '10'
      @warnings << "Video does not belong in the Music category."
    end
	end

	def create
		@youtube = Youtube.new(video_id: params[:id])
		@youtube.modify(params) ? (render 'success') : (render 'errors')
	end

	def update
		@youtube = Youtube.find_by_video_id(params[:id])
		@youtube.modify(params) ? (render 'success') : (render 'errors')
	end
end

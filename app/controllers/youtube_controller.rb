class YoutubeController < ApplicationController
	# :id parameter always refers to :video_id column.
  
	def new
		@youtube = Youtube.new(video_id: params[:id])
    @youtube.retrieve_api_data
		p = @youtube.performances.build
		p.compositions.build
		p.artists.build
		respond_to do |format|
			format.html { redirect_to youtube_path(@youtube) }
			format.js { render 'append_form' }
		end
	end

	def edit
		@youtube = Youtube.with_performances.find_by_video_id(params[:id])
		respond_to do |format|
			format.html { redirect_to youtube_path(@youtube) }
			format.js { render 'append_form' }
		end
	end

	def show
		@youtube = Youtube.with_performances.find_by_video_id(params[:id]) ||
      Youtube.new(video_id: params[:id])
    @youtube.retrieve_api_data
    @related = @youtube.related
	end

	def create
		@youtube = Youtube.new(video_id: params[:id])
		@youtube.modify(params) ? (render 'success') : (render 'errors')
	end

	def update
		@youtube = Youtube.with_performances.find_by_video_id(params[:id])
		@youtube.modify(params) ? (render 'success') : (render 'errors')
	end

  def search 
    client = GoogleAPI.new_client
    youtube_api = client.discovered_api('youtube', 'v3')      
    result = client.execute(
      api_method: youtube_api.search.list,
      parameters: {
        q: params[:search],
        part: 'id, snippet',
        maxResults: 25,
        type: 'video',
        videoEmbeddable: 'true',
        videoCategoryId: '10'
      }
    )
    @data = result.data
  end

  def index
    @youtubes = Youtube.order("updated_at DESC").limit(100)
  end
end

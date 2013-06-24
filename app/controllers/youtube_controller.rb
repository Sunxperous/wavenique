class YoutubeController < ApplicationController
  before_filter :validate_video_id, only: [:show]
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
    #@related = @youtube.related
    if (@youtube.api_data.present? &&
    @youtube.api_data.status.embeddable &&
    @youtube.api_data.status.privacyStatus == 'public')
      @form_performance = Form::Performance.new if
        @youtube.api_data.snippet.categoryId == '10'
    else
      render 'unavailable'
    end
	end

	def create
		@youtube = Youtube.new(video_id: params[:id])
		#@youtube.modify(params) ? (render 'success') : (render 'errors')
	end

	def update
		@youtube = Youtube.with_performances.find_by_video_id(params[:id])
		#@youtube.modify(params) ? (render 'success') : (render 'errors')
	end

  def search 
    @data = GoogleAPI.youtube('search', 'list', {
      q: params[:search],
      part: 'id, snippet',
      maxResults: 25,
      type: 'video',
      videoEmbeddable: 'true',
      videoCategoryId: '10'
    })
  end

  def index
    @youtubes = Youtube.order("updated_at DESC").limit(100)
  end

  private
  def validate_video_id
    render 'unavailable' unless params[:id].match(/[a-zA-Z0-9_-]{11}/)
  end
end

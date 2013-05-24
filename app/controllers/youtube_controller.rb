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
    @youtube.retrieve_api_data
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

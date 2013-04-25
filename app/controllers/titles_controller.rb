class TitlesController < ApplicationController
	def index
    @titles = Title.where(["title ILIKE ?", "%#{params[:find]}%"]).limit(10).all

    respond_to do |format|
      format.json { render json: @titles }
    end
	end
end

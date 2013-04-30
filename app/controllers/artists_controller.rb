class ArtistsController < ApplicationController
	def index
    @artists = Artist.where(["name ILIKE ?", "%#{params[:find]}%"]).limit(10).all

    respond_to do |format|
      format.json { render json: @artists }
    end
	end
end

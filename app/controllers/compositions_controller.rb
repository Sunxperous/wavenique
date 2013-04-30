class CompositionsController < ApplicationController
	def index
    @compositions = Composition.where(["title ILIKE ?", "%#{params[:find]}%"]).limit(10).all

    respond_to do |format|
      format.json { render json: @compositions }
    end
	end
end

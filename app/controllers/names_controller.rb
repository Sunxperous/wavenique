class NamesController < ApplicationController
	def index
    @names = Name.where(["name ILIKE ?", "%#{params[:find]}%"]).limit(10).all

    respond_to do |format|
      format.json { render json: @names }
    end
	end
end

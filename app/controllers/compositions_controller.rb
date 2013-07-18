class CompositionsController < ApplicationController
	def find 
    @compositions = Composition.where(["title ILIKE ?", "%#{params[:title]}%"]).limit(10).all

    respond_to do |format|
      format.json { render json: @compositions }
    end
	end

  def index
    # To redirect to search for now.
    @compositions = Composition.all
  end

  def show
    @composition = Composition.find(params[:id])
    if @composition.original_id.present? and @composition.original_id != @composition.id
      redirect_to artist_path @composition.original
    end
    @infolinks = Infolink.composition(@composition, count: 10)
  end

  def merge
    @composition = Composition.find(params[:id])
    target = params[:target_id]
    @composition.merge(target)
    redirect_to composition_path @composition.original
  end
end

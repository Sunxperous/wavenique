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
    @performances = Performance.
      joins("INNER JOIN performance_compositions ON performances.id = performance_compositions.performance_id").
      joins("INNER JOIN compositions ON performance_compositions.composition_id = compositions.id").
      joins("INNER JOIN youtubes ON youtubes.id = performances.youtube_id").
      where("compositions.id = ?", params[:id]).
      order("created_at DESC").
      limit(100).
      includes(:artists, :compositions, :youtube => :performances)
  end
end

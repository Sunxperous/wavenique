class ArtistsController < ApplicationController
	def find 
    @artists = Artist.where(["name ILIKE ?", "%#{params[:name]}%"]).limit(10).all

    respond_to do |format|
      format.json { render json: @artists }
    end
	end
  
  def index
    # Redirect to search for now.
    @artists = Artist.all
  end

  def show
    @artist = Artist.find(params[:id])
    if @artist.original_id.present? and @artist.original_id != @artist.id
      redirect_to artist_path @artist.original_id
    end
    @performances = Performance.
      joins("INNER JOIN performance_artists ON performances.id = performance_artists.performance_id").
      joins("INNER JOIN artists ON performance_artists.artist_id = artists.id").
      joins("INNER JOIN youtubes ON youtubes.id = performances.youtube_id").
      where("artists.id = ?", params[:id]).
      order("created_at DESC").
      limit(100).
      includes(:compositions, :artists, :youtube => :performances)
  end

  def merge
    @artist = Artist.find(params[:id])
    @target = params[:target_id]
    @artist.merge(@target)
    redirect_to artist_path @artist.original_id
  end
end

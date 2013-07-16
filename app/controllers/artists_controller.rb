class ArtistsController < ApplicationController
	def find 
    artists = Artist.
      joins(:aliases).
      where(["artist_aliases.name ILIKE ?", "%#{params[:name]}%"]).
      uniq.
      order('artists.id').
      limit(10)
    @json = artists.as_json(only: [:id], methods: [:name])

    respond_to do |format|
      format.json { render json: @json }
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
      where("deleted_at IS NULL").
      joins(performance_artists: :artist).
      where(artists: { id: params[:id] }).
      order("created_at DESC").
      limit(100).
      includes(:compositions, :artists, :wave => :performances)
  end

  def merge
    @artist = Artist.find(params[:id])
    @target = params[:target_id]
    @artist.merge(@target)
    redirect_to artist_path @artist.original_id
  end
end

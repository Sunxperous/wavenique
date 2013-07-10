class ArtistAliasesController < ApplicationController
  def index 
    #@aliases = ArtistAlias.where(artist_id: params[:artist_id]).order('proper DESC')
    @artist = Artist.find(params[:artist_id])
    @aliases = @artist.aliases.order('proper DESC')
  end

  def create
    artist = Artist.find(params[:artist_id])
    result = artist.aliases.create(name: params[:new_alias])
    @name = result.name
    respond_to do |format|
      format.js { render 'create' if result }
    end
  end
end

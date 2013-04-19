class UsersController < ApplicationController
  def index
  end

  def show
		@user = User.find_by_id(params[:id])
		@data = @user.playlists.data
  end
end

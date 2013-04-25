class UsersController < ApplicationController
  def index
  end

  def show
		@user = User.find_by_id(params[:id])
		if current_user?(@user)
			@data = @user.playlists.data
		end
  end
end

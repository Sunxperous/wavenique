class UsersController < ApplicationController
  def index
  end

  def show
		@user = User.find_by_id(params[:id])
		if current_user?(@user)
			@data = params.class
		end
  end
end

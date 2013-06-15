class TsunamiController < ApplicationController
  before_filter :admins_only

  def index
  end

  private
  def admins_only
    redirect_to root_path if !signed_in? or !current_user.admin?
  end
end

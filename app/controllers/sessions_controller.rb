class SessionsController < ApplicationController
  before_filter :not_signed_in, only: :google
  def destroy
    sign_out
    reset_session
    redirect_to root_path
  end

  def google
    if params[:code].present?
      @u = User::Google.sign_in(params[:code])
      sign_in @u 
      redirect_to @u 
    else
      redirect_to root_path
    end
  end

  private
  def not_signed_in
    redirect_to current_user if signed_in?
  end
end

class SessionsController < ApplicationController
  def destroy
    sign_out
    reset_session
    redirect_to root_path
  end

  def create
    # Should utilise "before_filter".
    # Limit to only Google sign ins in the future.
    if signed_in?
      redirect_to current_user
    elsif params[:code]
      @u = User.google_sign_in(params[:code])

      sign_in @u 
      redirect_to @u 
    else
      # Flash a notice that access has been denied.
      redirect_to root_path
    end
  end
end

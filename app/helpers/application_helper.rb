module ApplicationHelper
  include WaveHelper

  def title(page_title)
    content_for :title, page_title.to_s + ' ~ Wavenique'
  end

  def authentication_link
    if signed_in?
      link_to 'Sign out', signout_path
    elsif Rails.env.test?
      link_to 'Sign in', "https://accounts.google.com/o/oauth2/auth?client_id=863784091693.apps.googleusercontent.com&redirect_uri=http://localhost:8000/callback/google/&scope=https://gdata.youtube.com https://www.googleapis.com/auth/userinfo.profile&response_type=code&access_type=offline"
    else
      link_to 'Sign in', "https://accounts.google.com/o/oauth2/auth?client_id=863784091693.apps.googleusercontent.com&redirect_uri=http://localhost:3000/callback/google/&scope=https://gdata.youtube.com https://www.googleapis.com/auth/userinfo.profile&response_type=code&access_type=offline"
    end
  end

end

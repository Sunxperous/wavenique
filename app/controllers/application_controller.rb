class ApplicationController < ActionController::Base
  protect_from_forgery
	include SessionsHelper

	before_filter :google_api_tokens
end

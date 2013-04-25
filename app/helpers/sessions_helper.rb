module SessionsHelper
	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user?(user)
		user == current_user
	end

	def sign_out
		current_user = nil
		cookies.delete(:remember_token)
	end

	def signed_in_user
		unless signed_in?
			redirect_to root_path
		end
	end

	def google_api_tokens
		if signed_in?
			GoogleAPI.access_token = current_user.google_access_token
			GoogleAPI.refresh_token = current_user.google_refresh_token
		end
	end
end

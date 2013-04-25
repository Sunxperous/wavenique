FactoryGirl.define do
	factory(:user) do
		sequence(:google_id) { |n| "#{n}" }
		sequence(:google_name) { |n| "Name #{n}" }
		sequence(:google_refresh_token) { |n| "Refresh token #{n}" }
		sequence(:google_access_token) { |n| "Access token #{n}" }
	end
end

FactoryGirl.define do
  factory :user_google, class: User::Google do
    sequence(:site_id) { |n| "#{n}" }
    sequence(:refresh_token) { |n| "Refresh token #{n}" }
    sequence(:access_token) { |n| "Access token #{n}" }
    user
  end
end

FactoryGirl.define do
	factory :user do
    sequence(:name) { |n| "Name #{n}" }
  end
end

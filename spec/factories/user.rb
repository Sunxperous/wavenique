FactoryGirl.define do
	factory :user do
    sequence(:name) { |n| "Name #{n}" }

    factory :admin do
      admin true
    end
  end
end

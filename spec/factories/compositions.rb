# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :composition do
    sequence(:title) { |n| "Title #{n}" }
  end
end

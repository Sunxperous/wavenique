# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :artist_alias do
    sequence(:name) { |n| "Alias #{n}" }
    artist
    proper 0
  end
end

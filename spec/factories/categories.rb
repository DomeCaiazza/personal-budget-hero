FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }
    hex_color { Faker::Color.hex_color }
    association :user
    created_at { Time.now }
    updated_at { Time.now }
  end
end

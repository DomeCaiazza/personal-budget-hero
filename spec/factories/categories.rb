FactoryBot.define do
  factory :category do
    name { [ *('A'..'Z') ].sample(10).join }
    hex_color { Faker::Color.hex_color }
    association :user
    created_at { Time.now }
    updated_at { Time.now }
  end
end

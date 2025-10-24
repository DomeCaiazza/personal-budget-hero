FactoryBot.define do
  factory :account do
    name { [ *('A'..'Z') ].sample(10).join }
    created_at { Time.now }
    updated_at { Time.now }
  end
end

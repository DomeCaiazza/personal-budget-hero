FactoryBot.define do
  factory :subscription do
    description { Faker::Lorem.sentence }
    default_amount { Faker::Number.decimal(l_digits: 2) }
    subscription_type { Subscription.subscription_types.keys.sample }
    code { SecureRandom.hex(10) }
    association :user
    created_at { Time.now }
    updated_at { Time.now }
  end
end

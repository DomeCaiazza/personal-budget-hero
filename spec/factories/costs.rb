FactoryBot.define do
  factory :cost do
    description { Faker::Commerce.product_name }
    amount { Faker::Commerce.price(range: 0..1000.0, as_string: false) }
    date { (Date.today.beginning_of_month..Date.today.end_of_month).to_a.sample }
    paid { true }
    fixed { false }
    created_at { Time.now }
    updated_at { Time.now }
    association :user
    association :category
  end
end

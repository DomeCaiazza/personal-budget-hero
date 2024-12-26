FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'password_factory!' }
    password_confirmation { 'password_factory!' }
    reset_password_token { SecureRandom.hex(10) }
    reset_password_sent_at { Faker::Time.backward(days: 14, period: :evening) }
    remember_created_at { Faker::Time.backward(days: 30, period: :morning) }
    created_at { Time.now }
    updated_at { Time.now }
    role { 'user' }
  end
end

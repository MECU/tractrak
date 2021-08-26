FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::name }
    password { SecureRandom.hex }
  end
end

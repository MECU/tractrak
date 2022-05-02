FactoryBot.define do
  factory :athlete do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    height { rand(12) + 60 }
    gender { rand(2) }
    weight { rand(100) + 100 }
  end
end

FactoryBot.define do
  factory :stadium do
    name { Faker.name }
    google_name { Faker.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { State.first }
    zip { Faker::Address.zip }
    country { Country.first }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
  end
end

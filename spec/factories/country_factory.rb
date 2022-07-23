FactoryBot.define do
  factory :country do
    id { Country.maximum(:id) + 1 }
    name { Faker::Address.country }
    abbr { Faker::Address.country_code }
  end
end

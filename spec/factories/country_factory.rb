FactoryBot.define do
  factory :country do
    name { Faker::Address.country }
    abbr { Faker::Address.country_code }
  end
end

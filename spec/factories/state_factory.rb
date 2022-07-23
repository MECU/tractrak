FactoryBot.define do
  factory :state do
    id { State.maximum(:id) + 1 }
    name { Faker::Address.state }
    abbr { Faker::Address.state_abbr }
    country
  end
end

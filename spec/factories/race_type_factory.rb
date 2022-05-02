FactoryBot.define do
  factory :race_type do
    name { Faker::Lorem.words(3) }
    gender { rand(2) }
    athlete_team { rand(2) }
  end
end

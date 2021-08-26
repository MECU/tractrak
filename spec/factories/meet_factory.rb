FactoryBot.define do
  factory :meet do
    name { Faker::name }
    meet_date { DateTime.now + 1.day }
    owner { create(:user) }
    season
    stadium
    sponsor { SecureRandom.hex }

    trait :paid do
      paid { 1 }
    end

    trait :meet_key do
      SecureRandom.hex(16)
    end

    trait :points do
      {}
    end
  end
end

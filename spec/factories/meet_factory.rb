FactoryBot.define do
  factory :meet do
    name { Faker::Company.name }
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

    trait :in_the_future do
      meet_date { 2.months.from_now }
    end

    trait :in_the_past do
      meet_date { 2.months.ago }
    end

    trait :today do
      meet_date { Date.today }
    end

    trait :multi_day do
      meet_date { Date.today - 2.day }
      meet_end_date { Date.today + 2.day }
    end
  end
end

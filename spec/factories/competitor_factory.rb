FactoryBot.define do
  factory :competitor do
    race
    athlete
    team
    lane { rand(9) }

    trait :with_place do
      place { rand(9) }
    end

    trait :speedy_gonzales do
      athlete { create(:athlete, :speedy_gonzales) }
      team { create(:team, :high_school) }
    end

    trait :rocket_man do
      athlete { create(:athlete, :rocket_man) }
      team { create(:team, :high_school) }
    end
  end
end

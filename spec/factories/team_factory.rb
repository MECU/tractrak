FactoryBot.define do
  factory :team do
    name { Faker::Name.first_name }
    abbr { Faker::Name.last_name }
    state
    country

    trait :high_school do
      name { 'Team High School' }
    end
  end
end

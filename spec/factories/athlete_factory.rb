FactoryBot.define do
  factory :athlete do
    first_name { Faker.Person.first_name }
    last_name { Faker.Person.last_name }
    height { rand(12) + 60 }
    gender { rand(2) }
    weight { rand(100) + 100 }
  end
end

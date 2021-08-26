FactoryBot.define do
  factory :season do
    season { Date.today }
    state
    country
    classification_id { Random }
    level_id { Random }
  end
end

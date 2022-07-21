FactoryBot.define do
  factory :race do
    meet
    race_type
    start { "#{rand(24)}:#{rand(60)}:#{rand(60)}" }
    wind { rand(9.9) - rand(9.9) }
  end
end

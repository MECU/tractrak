class Race < ApplicationRecord
  belongs_to :meet
  belongs_to :race_type
  has_many :athletes # competitor

  def athlete_race?
    race_type.athlete_race?
  end

  def team_race?
    race_type.team_race?
  end

  def first_place
    competitors = athlete_race? ? athletes : teams

    competitors.where('place', 1).first
  end
end

class RaceType < ApplicationRecord
  has_many :races

  def athlete_race?
    athlete_team == false
  end

  def team_race?
    athlete_team
  end
end

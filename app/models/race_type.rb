class RaceType < ApplicationRecord
  has_many :races

  # TODO check if this still works this way
  def athlete_race?
    athlete_team === 0
  end

  def team_race?
    athlete_team === 1
  end
end

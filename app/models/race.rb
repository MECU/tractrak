class Race < ApplicationRecord
  belongs_to :meet
  belongs_to :race_type, inverse_of: :races
  has_many :competitors, :dependent => :delete_all
  has_many :athletes, through: :competitors
  has_many :teams, through: :competitors

  def athlete_race?
    race_type.athlete_race?
  end

  def team_race?
    race_type.team_race?
  end

  def first_place
    # competitors = athlete_race? ? athletes : teams
    competitors.where(place: 1).first
  end

  def has_results?
    competitors.where.not(result: nil).count > 0
  end

  def competitors_sorted
    if race_type.track?
      if has_results?
        competitors.order(Arel.sql("string_to_array(competitors.result, '.')::text[]"))
      else
        competitors.order(:lane)
      end
    else
      competitors.order(Arel.sql("string_to_array(competitors.result, '-')::int[] DESC"))
    end
  end
end

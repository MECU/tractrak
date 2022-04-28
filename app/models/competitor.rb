class Competitor < ApplicationRecord
  belongs_to :team
  belongs_to :athlete, optional: true
  belongs_to :race

  validates :lane, presence: true

  # Results are stored in seconds
  # This will convert to MM:SS.sss for display
  def result_display
    return if result.nil?
    return sprintf('%6.3f', result) if result.to_f < 60.0

    min = result.to_i / 60
    sec = result.to_f % 60

    sprintf('%2d:%06.3f', min, sec)
  end
end

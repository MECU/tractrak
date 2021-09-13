class Competitor < ApplicationRecord
  belongs_to :team, optional: true
  belongs_to :athlete, optional: true
  belongs_to :race

  validates :lane, presence: true
end

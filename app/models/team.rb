class Team < ApplicationRecord
  include Discard::Model

  validates :name, presence: true

  has_many :careers
  has_many :athletes, through: :careers
  has_many :competitors
  has_many :races, through: :competitors

  belongs_to :state

  def self.finder(name:, create: false)
    # TODO: Need to find teams better, filtering by state at least
    Team.where(name: name).first_or_create!(abbr: name[0, 4], state_id: 6)
  end
end

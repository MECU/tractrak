class Team < ApplicationRecord
  include Discard::Model

  validates :name, presence: true

  has_many :careers
  has_many :athletes, through: :careers
  has_many :competitors
  has_many :races, through: :competitors

  has_one :state

  def self.finder(name:, create: false)
    # TODO: Need to find teams better, filtering by state at least
    team = Team.where(name: name)

    return team.first! if team.exists?

    raise ActiveRecord::RecordNotFound unless create

    team.abbr = name[0, 4]
    team.save!
    team
  end
end

class Team < ApplicationRecord
  include Discard::Model

  validates :name, presence: true

  has_many :careers
  has_many :athletes, through: :careers
  has_many :competitors
  has_many :races, through: :competitors

  belongs_to :state
  belongs_to :country

  def self.finder(name:, state_id: 6, create: false)
    team = Team.where(name: name).where(state_id: state_id)

    return team.first! if team.exists?

    raise ActiveRecord::RecordNotFound unless create

    state = State.find(state_id)
    team = team.build
    team.name = name
    team.abbr = name[0, 4]
    team.state = state
    team.country = state.country
    team.save!
    team
  end
end

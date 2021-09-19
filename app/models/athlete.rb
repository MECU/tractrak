class Athlete < ApplicationRecord
  include Discard::Model

  has_many :careers
  has_many :teams, through: :careers
  has_many :competitors
  has_many :races, through: :competitors

  def picture?
    false
  end

  def url
    name.sub(' ', '-')
  end

  def current_team
    careers.where(current: true).first
  end

  #  If the team they are assigned to isn't their current team
  #  Update all other teams to false, then add this one
  def set_current_team(team)
    return unless team != current_team

    careers.update_all(current: false)
    careers.where(team: team).first_or_create!(current: true)
  end

  def self.finder(name:, gender: nil, create: false)
    # TODO: Add more search capability
    athlete = Athlete.where(name: name)
    athlete.where(gender: gender) unless gender.nil?
    return athlete.first! if athlete.exists?

    raise ActiveRecord::RecordNotFound unless create

    athlete.create!
  end
end

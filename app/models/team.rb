class Team < ApplicationRecord
  include Discard::Model

  validates :name, presence: true

  has_many :careers
  has_many :athletes, through: :careers
  has_many :competitors
  has_many :races, through: :competitors

  has_one :state
end

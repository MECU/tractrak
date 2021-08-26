class Team < ApplicationRecord
  include Discard::Model

  validates :name, presence: true

  belongs_to :athlete # current?
  belongs_to :race
  has_one :state
end

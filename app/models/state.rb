class State < ApplicationRecord
  include Discard::Model

  belongs_to :country
  has_many :teams
end

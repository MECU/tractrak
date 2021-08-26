class State < ApplicationRecord
  include Discard::Model

  has_many :teams
end

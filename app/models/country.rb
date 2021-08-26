class Country < ApplicationRecord
  has_many :teams, through: :states
  has_many :states
end

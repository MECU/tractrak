class Season < ApplicationRecord
  has_many :meets
  belongs_to :state
  belongs_to :country
end

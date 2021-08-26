class Stadium < ApplicationRecord
  include Discard::Model

  has_many :meets
  has_one :state
  has_one :country

  def name_with_city_state
    "#{name} (#{city}, #{state.abbr}"
  end
end

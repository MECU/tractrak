class Stadium < ApplicationRecord
  include Discard::Model

  has_many :meets
  belongs_to :state
  belongs_to :country

  def name_with_city_state
    "#{name} (#{city}, #{state.abbr})"
  end
end

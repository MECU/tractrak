class Athlete < ApplicationRecord
  include Discard::Model

  has_and_belongs_to_many :teams # current?
  has_many :races, through: :competitor
  # $this->morphToMany('App\Models\Race', 'competitor')->withPivot('id', 'lane', 'result', 'place')

  def picture?
    false
  end

  def url
    name.sub(' ', '-')
  end
end

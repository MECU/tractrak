require 'rails_helper'

RSpec.describe RaceType, type: :model do
  let(:race_type) { create(:race_type) }

  it 'works' do
    race_type
  end
end

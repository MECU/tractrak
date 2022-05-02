require 'rails_helper'

RSpec.describe Race, type: :model do
  let(:meet) { create(:meet) }
  let(:race) { create(:race, meet: meet) }

  it 'works' do
    race
  end
end

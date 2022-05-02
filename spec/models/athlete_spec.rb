require 'rails_helper'

RSpec.describe Athlete, type: :model do
  let(:athlete) { create(:athlete) }

  it 'works' do
    athlete
  end
end

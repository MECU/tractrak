require 'rails_helper'

RSpec.describe Competitor, type: :model do
  let(:competitor) { create(:competitor) }

  it 'factory works' do
    competitor
  end
end

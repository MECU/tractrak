require 'rails_helper'

RSpec.describe Meet, type: :model do
  let(:meet) { create(:meet) }

  it 'factory works' do
    meet
  end
end

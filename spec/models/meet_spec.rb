require 'rails_helper'

RSpec.describe Meet, type: :model do
  let(:meet) { create(:meet) }
  let(:race) { create(:race, meet: meet, event: 1, round: 1, heat: 1) }
  let(:fixture) { file_fixture(filename).read }

  it 'factory works' do
    meet
  end

  describe '#lif_file' do
    let(:filename) { '001-1-1.lif' }

    it 'deletes lanes not found in the CSV' do
      create(:competitor, :speedy_gonzales, race: race, lane: 1)
      create(:competitor, :rocket_man, race: race, lane: 2)

      7.times do |lane|
        race.competitors << create(:competitor, race: race, lane: lane+3)
      end

      meet.reload
      expect(meet.races.first.competitors.count).to eq(9)

      meet.lif_file(fixture)
      meet.reload

      expect(meet.races.first.competitors.count).to eq(2)
    end
  end
end

require 'rails_helper'

RSpec.describe DashboardController do
  let(:meet) { create(:meet, ppl: true) }
  let(:country) { create(:country, id: 1) }
  let!(:state) { create(:state, id: 6, country: country) }
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  def upload(filename)
    fixture = fixture_file_upload(filename, 'text/csv')
    file = Hash.new
    file['file'] = fixture

    post :preload, params: { meet_files: file, id: meet.id }
  end

  describe 'EVT file re-upload' do
    it 'handles splitting a heat into two' do
      upload('lynx-800.evt')
      expect(response.successful?).to be_truthy

      upload('lynx-800.sch')
      expect(response.successful?).to be_truthy

      meet.reload
      expect(meet.evt).to eq(true)
      expect(meet.races.count).to eq(1)
      expect(meet.races.first['event']).to eq(18)
      expect(meet.races.first['heat']).to eq(1)
      expect(meet.races.first['round']).to eq(1)
      expect(meet.races.first['schedule']).to eq(1)
      expect(meet.races.first.competitors.count).to eq(41)

      # Now event is split into two heats
      upload('lynx-800-2.evt')
      expect(response.successful?).to be_truthy

      expect(meet.races.count).to eq(2)
      expect(meet.races.first['event']).to eq(18)
      expect(meet.races.first['round']).to eq(1)
      expect(meet.races.first['heat']).to eq(1)
      expect(meet.races.first['schedule']).to eq(1)
      expect(meet.races.last['event']).to eq(18)
      expect(meet.races.last['round']).to eq(1)
      expect(meet.races.last['heat']).to eq(2)
      expect(meet.races.last['schedule']).to eq(2)
      expect(meet.races.first.competitors.count).to eq(19)
      expect(meet.races.last.competitors.count).to eq(22)
    end

    it 'handles merging two heats into one' do
      upload('lynx-800-2.evt')
      expect(response.successful?).to be_truthy

      upload('lynx-800-2.sch')
      expect(response.successful?).to be_truthy

      meet.reload

      expect(meet.races.count).to eq(2)
      expect(meet.races.first['event']).to eq(18)
      expect(meet.races.first['round']).to eq(1)
      expect(meet.races.first['heat']).to eq(1)
      expect(meet.races.first['schedule']).to eq(1)
      expect(meet.races.last['event']).to eq(18)
      expect(meet.races.last['round']).to eq(1)
      expect(meet.races.last['heat']).to eq(2)
      expect(meet.races.last['schedule']).to eq(2)
      expect(meet.races.first.competitors.count).to eq(19)
      expect(meet.races.last.competitors.count).to eq(22)

      # Now event is merged into one
      upload('lynx-800.evt')
      expect(response.successful?).to be_truthy

      expect(meet.evt).to eq(true)
      expect(meet.races.count).to eq(1)
      expect(meet.races.first['event']).to eq(18)
      expect(meet.races.first['heat']).to eq(1)
      expect(meet.races.first['round']).to eq(1)
      expect(meet.races.first['schedule']).to eq(1)
      expect(meet.races.first.competitors.count).to eq(41)
    end

    it 'does not delete an event with results but can add' do
      upload('lynx-800-2.evt')
      expect(response.successful?).to be_truthy

      upload('lynx-800-2.sch')
      expect(response.successful?).to be_truthy

      # in order to test a race can have additions with results
      race = Race.first
      competitor = race.competitors.first
      competitor.result = '9.99'
      competitor.place = '1'
      competitor.save!

      race = Race.last
      competitor = race.competitors.first
      competitor.result = '9.99'
      competitor.place = '1'
      competitor.save!
      expect(race.has_results?).to be(true)

      # Now event is attempted to be merged into one
      upload('lynx-800.evt')
      expect(response.successful?).to be_truthy

      races = meet.races.order(:schedule)
      expect(races.count).to eq(2)
      expect(races.first['event']).to eq(18)
      expect(races.first['round']).to eq(1)
      expect(races.first['heat']).to eq(1)
      expect(races.first['schedule']).to eq(1)
      expect(races.last['event']).to eq(18)
      expect(races.last['round']).to eq(1)
      expect(races.last['heat']).to eq(2)
      expect(races.last['schedule']).to eq(2)
      # It's okay to add, even to a race with results
      expect(races.first.competitors.count).to eq(19)
      expect(races.last.competitors.count).to eq(22)
    end

    it 'handles adding a round' do
      upload('lynx-800.evt')
      expect(response.successful?).to be_truthy

      upload('lynx-800.sch')
      expect(response.successful?).to be_truthy

      upload('lynx-800-round-2.evt')
      expect(response.successful?).to be_truthy

      meet.reload

      expect(meet.races.count).to eq(3)
      expect(meet.races.first['event']).to eq(18)
      expect(meet.races.first['round']).to eq(1)
      expect(meet.races.first['heat']).to eq(1)
      expect(meet.races.first['schedule']).to eq(1)
      expect(meet.races.last['event']).to eq(18)
      expect(meet.races.last['round']).to eq(2)
      expect(meet.races.last['heat']).to eq(1)
      expect(meet.races.last['schedule']).to eq(3)
      expect(meet.races.first.competitors.count).to eq(19)
      expect(meet.races.last.competitors.count).to eq(9)
    end
  end
end
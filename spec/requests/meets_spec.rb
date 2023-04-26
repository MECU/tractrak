require 'rails_helper'

RSpec.describe "Meets", type: :request do
  let(:meet) { create(:meet, :meet_key) }
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  def upload(filename)
    fixture = fixture_file_upload(filename, 'text/csv')
    file = Hash.new
    file['file'] = fixture

    post "/meet/preload/#{meet.id}", params: { meet_files: file, id: meet.id }
  end

  def upload_lif(filename)
    file = File.read(Rails.root + 'spec/fixtures/files/mustang/' + filename)
    params = {filename:, file:, key: meet.meet_key }

    post("/api/meet-file", params:)
  end

  describe 'Mustang Meet' do
    it 'handles the meet' do
      upload('mustang/lynx.ppl')
      expect(response.successful?).to be_truthy

      upload('mustang/lynx.evt')
      expect(response.successful?).to be_truthy

      upload('mustang/lynx.sch')
      expect(response.successful?).to be_truthy
      expect(meet.reload.races.count).to eq(146)

      upload_lif('001-1-01.lif')
      expect(response.successful?).to be_truthy

      expect { upload_lif('001-1-01.lif') }.to have_broadcasted_to("meet-#{meet.id}")

      upload_lif('001-1-01.lif')
      expect(response.successful?).to be_truthy

      race = Race.where(meet_id: meet.id, event: 1, round: 1, heat: 1).first!
      expect(race.competitors.count).to eq(9)

      expect { upload_lif('001-1-02.lif') }.to(
        have_broadcasted_to("meet-#{meet.id}").exactly(:once).with(/Heat 2/)
        .and have_broadcasted_to("meet-#{meet.id}").exactly(:once).with(/Combined Results/))

      upload_lif('001-1-03.lif')
      expect(response.successful?).to be_truthy

      upload_lif('002-1-01.lif')
      expect(response.successful?).to be_truthy

      upload_lif('003-1-01.lif')
      expect(response.successful?).to be_truthy
      upload_lif('003-1-02.lif')
      expect(response.successful?).to be_truthy

      upload_lif('004-1-01.lif')
      expect(response.successful?).to be_truthy
      upload_lif('004-1-02.lif')
      expect(response.successful?).to be_truthy
      upload_lif('004-1-03.lif')
      expect(response.successful?).to be_truthy
      upload_lif('004-1-04.lif')
      expect(response.successful?).to be_truthy
      upload_lif('004-1-05.lif')
      expect(response.successful?).to be_truthy
      upload_lif('004-1-06.lif')
      expect(response.successful?).to be_truthy
      upload_lif('004-1-07.lif')
      expect(response.successful?).to be_truthy
      upload_lif('004-1-08.lif')
      expect(response.successful?).to be_truthy

      race = Race.where(meet_id: meet.id, event: 4, round: 1, heat: 1).first!
      expect(race.wind).to eq(0.1e1)
    end
  end

end

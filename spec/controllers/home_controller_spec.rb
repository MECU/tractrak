require 'rails_helper'

RSpec.describe HomeController do
  let!(:meet_today) { create(:meet, :today) }
  let!(:meet_past) { create(:meet, :in_the_past) }
  let!(:meet_future) { create(:meet, :in_the_future) }
  let!(:meet_multi) { create(:meet, :multi_day) }

  before do
    get :index
  end

  it 'shows the meets appropriately' do
    expect(response).to be_ok
    expect(assigns(:current_meets)).to match_array([meet_today, meet_multi])
    expect(assigns(:upcoming_meets)).to match_array([meet_future])
    expect(assigns(:recent_meets)).to match_array([meet_past])
  end
end
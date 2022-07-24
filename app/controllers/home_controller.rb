class HomeController < ApplicationController
  def index
    Time.zone = 'America/Denver'

    today_meets = Meet.order(meet_date: :asc).where(meet_date: Time.zone.today.all_day)
    multi_day_meets = Meet.order(meet_end_date: :asc).where(meet_end_date: Time.zone.now..)
    @current_meets = today_meets + multi_day_meets
    @upcoming_meets = Meet.order(meet_date: :asc).where(meet_date: Time.zone.now..).take(5)
    @recent_meets = Meet.order(meet_date: :desc).where(meet_date: ..Time.zone.today).take(5) - multi_day_meets
  end
end

class HomeController < ApplicationController
  def index
    @current_meets = Meet.order(meet_date: :asc).where(meet_date: Date.today.all_day)
    @upcoming_meets = Meet.order(meet_date: :asc).where(meet_date: Time.now..).take(5)
    @recent_meets = Meet.order(meet_date: :desc).where(meet_date: ..Time.now).take(5)
  end
end

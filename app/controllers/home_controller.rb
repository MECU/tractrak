class HomeController < ApplicationController
  def index
    @current_meets = Meet.where(meet_date: Date.today.all_day).map(&:serialized)
    @upcoming_meets = Meet.order(meet_date: :desc).where(meet_date: Time.now..).take(5).map(&:serialized)
    @recent_meets = Meet.order(meet_date: :desc).where(meet_date: ..Time.now).take(5).map(&:serialized)
  end
end

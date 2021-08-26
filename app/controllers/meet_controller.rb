class MeetController < ApplicationController
  def upcoming_meets
    Meet.order(meet_date: :desc).take(5).map(&:serialized)
  end

  def current_meets
    Meet.where(meet_date: today.all_day).map(&:serialized)
  end

  def meet

  end

  def event

  end

  def live

  end

  def team_standings

  end

  def pdf
    # TODO
  end
end

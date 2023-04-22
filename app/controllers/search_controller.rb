class SearchController < ApplicationController
  def index
  end

  def search
    @meets = Meet.where("name ILIKE ?", "%#{params[:query]}%")
                 .order('meet_date DESC')
                 .take(10)
    render partial: "meet", locals: { meets: @meets }
  end
end

class AthleteController < ApplicationController
  def view
    @athlete = Athlete.includes(:teams, :races).find(params[:id])
  end
end

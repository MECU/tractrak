class DashboardController < ApplicationController
  before_action :authenticate_user!

  def create_meet
    Time.zone = params['meet']['time_zone'].to_s
    params['meet']['meet_date'] = DateTime.civil(params['meet']['meet_date(1i)'].to_i,
                                                 params['meet']['meet_date(2i)'].to_i,
                                                 params['meet']['meet_date(3i)'].to_i,
                                                 params['meet']['meet_date(4i)'].to_i,
                                                 params['meet']['meet_date(5i)'].to_i,
                                                 0,
                                                 Time.zone.utc_offset / 1.hour.to_i)
    meet = Meet.create(params.require(:meet).permit(:name, :meet_date, :sponsor))
    meet.owner = current_user
    meet.save!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.prepend(:dashboard_meets, partial: 'meet', locals: { meet: meet }),
          turbo_stream.replace(:create_meet, partial: 'meet_create')
        ]
      end

      format.html { redirect_to live_meet_url(meet) }
    end
  end
end

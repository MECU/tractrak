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
    meet = Meet.create(params.require(:meet).permit(:name, :meet_date, :sponsor, :time_zone))
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

  def run
    @meet = Meet.find(params[:id])

    # See if the user is the owner
    render text: 'You are not authorized to edit this meet.', status: 401 if @meet.owner != current_user
  end

  def download_key
    @meet = Meet.find(params[:id])

    render text: 'Only the meet owner may download the key.', status: 400 if current_user != @meet.owner

    # Generate 32-bit random string (or grab from Meet, if exists)
    if @meet.meet_key.nil?
      @meet.meet_key = SecureRandom.alphanumeric(32)
      @meet.save!
    end

    send_data(@meet.meet_key, filename: 'tractrak.key')
  end

  def preload
    puts params[:meet_files][:file]
    file = params[:meet_files][:file]
    file_extension = file.original_filename.split('.').last

    unless %w[ppl evt sch lif].include?(file_extension)
      render text: 'That is not a valid file extension. Please be sure to upload lynx.ppl or lynx.evt or lynx.sch files.', status: 400
    end

    @meet = Meet.find(params[:id])

    case file_extension
    when 'ppl'
      @meet.ppl_process(file)
    when 'evt'
      @meet.evt_process(file)
    when 'sch'
      @meet.sch_process(file)
    when 'lif'
      @race = @meet.lif_file(file)

      @race.broadcast_replace_to "meet-#{@meet.id}",
                                 partial: 'meet/race',
                                 target: "meet-#{@meet.id}-race-#{@race.id}",
                                 locals: { race: @race }

      @races = @meet.completed_races_by_event(@race.event)
      @race.broadcast_replace_to "meet-#{@meet.id}",
                                 partial: 'meet/event',
                                 target: "meet-#{@meet.id}-event-#{@race.event}-combined",
                                 locals: { meet: @meet, races: @races, event: @race.event }
    end

    @meet.reload

    render :run
  end
end

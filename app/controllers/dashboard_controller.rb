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

  def run
    @meet = Meet.find(params[:id])

    # See if the user is the owner
    abort(401, 'You are not authorized to edit this meet.') if @meet.owner != current_user
  end

  def download_key
    @meet = Meet.find(params[:id])

    abort(['error' => 'Only the meet owner may download the key.'], 400) if current_user != @meet.owner

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

    unless %w[ppl evt sch].include?(file_extension)
      raise Error(400, 'That is not a valid file extension. Please be sure to upload lynx.ppl or lynx.evt or lynx.sch files.')
    end

    @meet = Meet.find(params[:id])

    case file_extension
    when 'ppl'
      @meet.ppl_process(file)
    when 'evt'
      @meet.evt_process(file)
    when 'sch'
      @meet.sch_process(file)
    end

    @meet.reload

    render :run
  end
end

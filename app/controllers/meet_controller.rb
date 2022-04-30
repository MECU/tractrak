class MeetController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :api

  def meet

  end

  def api
    Rails.logger.debug "[Process File Request] [params: #{params}]"

    # Get the 32 char auth key 
    key = params.require(:key)
    Rails.logger.debug "[Process File Request] [key: #{key}]"

    # Determine the meet
    @meet = Meet.find_by!(meet_key: key)

    # Check file extension
    filename = params.require(:filename)
    file_extension = filename.split('.').last.downcase
    if file_extension != 'lif'
      return render text: 'Only .LIF files are allowed.', status: 422
    end

    # Process the file
    file = params.require(:file)
    Rails.logger.debug "[Process File Request] [file: #{file}]"
    @race = @meet.lif_file(file)

    if @race.nil?
      return render text: 'The .LIF file was not processed correctly. Race not found', status: 422
    end

    @race.broadcast_replace_to "meet-#{@meet.id}",
                               partial: 'meet/race',
                               target: "meet-#{@meet.id}-race-#{@race.id}",
                               locals: { race: @race }

    @races = @meet.completed_races_by_event(@race.event)
    if @races.count > 1
      @race.broadcast_replace_to "meet-#{@meet.id}",
                                 partial: 'meet/event',
                                 target: "meet-#{@meet.id}-event-#{@race.event}-combined",
                                 locals: { meet: @meet, races: @races, event: @race.event }
    end

    render json: { status: 'success' }, status: :ok
  end

  def live
    @meet = Meet.find(params[:id])
  end

  def data
    @meet = Meet.includes(:races, :competitors).order('races.schedule').find(params[:id])

    render partial: 'meet/meet', locals: { meet: @meet }
  end

  def race
    @race = Race.find(params[:race])

    render partial: 'meet/race', locals: { race: @race }
  end

  def event
    @meet = Meet.find(params[:meet])
    @races = @meet.completed_races_by_event(params[:event])

    render partial: 'meet/event', locals: { meet: @meet, races: @races, event: params[:event] }
  end

  def team_standings

  end

  def pdf
    @meet = Meet.find(params[:id])

    html = render_to_string(template: 'meet/flyer', locals: { meet: @meet }, layout: false)
    pdf = WickedPdf.new.pdf_from_string(html)

    send_data(
      pdf,
      filename: "tractrak-meet-#{@meet.id}.pdf",
      disposition: 'attachment',
      show_as_html: true
    )
  end
end

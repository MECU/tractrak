class MeetController < ApplicationController
  include Broadcast

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
    Rails.logger.debug "[Process File Request] [file_extension: #{file_extension}]"
    file = params.require(:file)
    Rails.logger.debug "[Process File Request] [file: #{file}]"

    # Process the file
    if file_extension == 'lif'
      Rails.logger.debug '[Process LIF File Request]'
      @race = @meet.lif_file(file)

      if @race.nil?
        return render text: 'The .LIF file was not processed correctly. Race not found', status: 422
      end
    elsif file_extension == 'sch'
      Rails.logger.debug '[Process SCH File Request]'
      @race = @meet.sch_process(file)
      @meet.broadcast_meet
    elsif file_extension == 'ppl'
      Rails.logger.debug '[Process PPL File Request]'
      @race = @meet.ppl_process(file)
    else
      return render text: 'Only .LIF, .PPL, .SCH, or .EVT files are allowed.', status: 422
    end

    broadcast_race(meet: @meet, race: @race)

    render json: { status: 'success' }, status: :ok
  end

  def live
    @meet = Meet.find(params[:id])
  end

  def data
    @meet = Meet.includes(:races, :race_types, :competitors)
                .order('race_types.track_field')
                .order('races.schedule')
                .find(params[:id])

    render partial: 'meet/meet', locals: { meet: @meet }
  end

  def race
    @race = Race.find(params[:race])

    render partial: 'meet/race', locals: { race: @race }
  end

  def event
    meet = Meet.find(params[:meet])
    races = meet.completed_races_by_event(params[:event])
    
    render partial: 'meet/event', locals: { meet:, races:, event: params[:event] }
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

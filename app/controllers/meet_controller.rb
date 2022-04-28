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

    # Save the file
    file = params.require(:filename)
    Rails.logger.debug "[Process File Request] [file: #{file}]"

    # Process the file
    file_extension = file.original_filename.split('.').last
    if file_extension.downcase == 'lif'
      @race = @meet.lif_file(file)
    end

    if @race.nil?
      return response(
        [
          'status': 'fail',
          'message': 'The .LIF file was not processed correctly'
        ]
      )
    end

    @race.broadcast_replace_to "meet-#{@meet.id}",
                               partial: 'meet/race',
                               target: "meet-#{@meet.id}-race-#{@race.id}",
                               locals: { race: @race }

    @races = @meet.completed_races_by_event(params[:event])
    @race.broadcast_replace_to "meet-#{@meet.id}",
                               partial: 'meet/event',
                               target: "meet-#{@meet.id}-event-#{@race.event}-combined",
                               locals: { meet: @meet, races: @races, event: @race.event }

    render json: { status: 'success' }
  end

  def live
    @meet = Meet.find(params[:id])
  end

  def data
    @meet = Meet.find(params[:id])

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

  private

  def write_meet_file
    # filename = storage_path('meets/' . strtolower(preg_replace('/\s+/', '', meet.name))) . "/file"
    # dirname = dirname(filename)
    #
    # if !is_dir(dirname)
    #   Rails.logger.debug("trying to create directory dirname")
    #   mkdir(dirname, 0777, true)
    # end
    #
    # Rails.logger.debug("trying to write file filename")
    # if !file_put_contents(filename, data)
    #   Rails.loggercritical('[Process File Request] Could not write to file', ['filename': filename])
    # throw new \RuntimeException('File could not be written: ' . filename)
    # end
    #
    # filename
  end
end

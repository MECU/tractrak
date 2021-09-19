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
    file = params.require('file')
    # Rails.logger.debug "[Process File Request] [filename: #{filename}]"
    Rails.logger.debug "[Process File Request] [file: #{file}]"

    # filename = write_meet_file(meet, filename, file_contents)

    # Process the file
    file_extension = file.original_filename.split('.').last
    if file_extension == 'lif'
      event_round_heat = lif_file(file, @meet.id)
    end
    if event_round_heat.nil?
      return response(
        [
          'status': 'fail',
          'message': 'The .LIF file was not processed correctly'
        ]
      )
    end

    @meet.broadcast_replace_later_to "meet-#{@meet.id}", partial: 'meet/meet', target: "meet-#{@meet.id}", locals: { meet: @meet }

    {status: 'success'}.to_json
  end

  def live
    @meet = Meet.find(params[:id])
  end

  def data
    @meet = Meet.find(params[:id])

    render partial:'meet/meet', locals: { meet: @meet }
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

  def lif_file(file, meet_id)
    puts 'hi'
    ActiveRecord::Base.transaction do
      CSV.foreach(file.path, headers: false).with_index(1) do |row, row_counter|
        puts 'csv start'
        if row_counter === 1
          puts 'row 1'
          # row will be an array containing the comma-separated elements of the line:
          # array(
          #   0: @event_id,
          #   1: round
          #   2: heat
          #   3: name
          #   4: wind number
          #   5: wind units (m/s)
          #   9: distance?
          #   10: Time of day (local) started
          # )
          @event_id = row[0]
          @round_id = row[1]
          @heat_id = row[2]

          @race = Race.where(
            meet_id: meet_id,
            event: @event_id,
            round: @round_id,
            heat: @heat_id,
          ).first!

          if row[10].present?
            @race.start = row[10]
          end

          if row[4].present?
            @race.wind = row[4]
          end

          @race.save!

          Rails.logger.debug("Row 1 processed for #{row[3]}: #{@event_id}|#{@round_id}|#{@heat_id}")
        else
          puts 'row other'
          if row[1].nil?
            # Team event
            # row will be an array containing the comma-separated elements of the line:
            # array(
            #   0: place
            #   1: (blank) - this implies it's a team event
            #   2: lane
            #   3: Team name
            #   4: ?
            #   5: team abbreviation
            #   6: time
            #   7: ?
            #   8: delta time from previous position
            #   9: ?
            #   10: ?
            #   11: time of day (local) started
            #   12: ?
            #   13: ?
            #   14: ?
            #   15: delta time from previous position?
            #   16: delta time from previous position?
            # )

            team = Team.find(name: row[3])

            lane = @race.teams.where(lane: row[2]).find(team.id)

            if lane.id.nil?
              # Something has gone wrong, so abort
              @heat_id = null
              break
            end
            # Rails.logger.debug(row[2])
            # Rails.logger.debug(team)
            # Rails.logger.debug(lane)
            # Rails.logger.debug(lane.pivot)

            updated = Competitor.where(id: lane.id).update_all(
              {
                result: row[6],
                place: row[0],
              }
            )

            if updated == 1
              Rails.logger.debug("Row successfully processed for team, lane {row[2]}, {row[3]}: {row[0]}: {row[6]}")
            else
              Rails.logger.error("Row NOT processed for team, lane {row[2]}, {row[3]}: {row[0]}: {row[6]}")
              Rails.logger.debug(@race.teams)
            end
          else
            # Athlete event
            # row will be an array containing the comma-separated elements of the line:
            # array(
            #   0: place
            #   1: athleteId
            #   2: lane
            #   3: LastName
            #   4: FirstName
            #   5: Team
            #   6: time
            #   7: ?
            #   8: delta time from previous position
            #   9: ?
            #   10: ?
            #   11: time of day (local) started
            #   12: gender?
            #   13: Races (one is int, two is csv list in quotes ")
            #   14: ?
            #   15: delta time from previous position?
            #   16: delta time from previous position?
            # )

            # if (!empty(row[12])) {
            #     gender = row[12] === 'M' ? 0 : 1
            #     athlete = Athlete.where(['firstname': row[4], 'lastname': row[3], 'gender': gender]).firstOrFail()
            # } else {
            athlete = Athlete::finder(name: "#{row[4]} #{row[3]}")

            lane = @race.competitors.find_by(athlete: athlete)

            if lane.nil?
              # Something has gone wrong, so abort
              @heat_id = null
              break
            end

            if row[0].present?
              lane.place = row[0]
            end
            if row[6].present?
              lane.result = row[6]
            end


            if lane.save!
              Rails.logger.debug("updated row successfully processed for athlete, lane #{row[2]}, #{row[4]} #{row[3]}: #{row[0]}: #{row[6]}")
            else
              Rails.logger.debug("updated Row NOT processed for athlete, lane #{row[2]}, #{row[4]} #{row[3]}: #{row[0]}: #{row[6]}")
              Rails.logger.debug(@race.athletes)
            end
          end
        end
      end

    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.debug(e)
    end

    if @event_id.nil? || @round_id.nil? || @heat_id.nil?
      Rails.logger.debug("Did not have event or round or heat: #{@event_id}|#{@round_id}|#{@heat_id}")
      return []
    end

    Rails.logger.debug("Successfully processed event|round|heat: #{@event_id}|#{@round_id}|#{@heat_id}")

    ['event': @event_id, 'round': @round_id, 'heat': @heat_id]
  end
end

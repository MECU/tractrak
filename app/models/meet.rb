require 'csv'

class Meet < ApplicationRecord
  # include Discard.Model

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :season, optional: true
  belongs_to :stadium, optional: true
  has_many :races
  has_many :competitors, through: :races
  has_many :race_types, through: :races

  def url_name
    name.gsub(' ', '-').gsub(/,'"`'/, '').downcase
  end

  def paid?
    true
    # paid === 1 # enable when paying is required
  end

  def ready?
    sch && evt && ppl && paid?
  end

  def qr(text, size = 10)
    require 'barby'
    require 'barby/barcode'
    require 'barby/barcode/qr_code'
    require 'barby/outputter/png_outputter'
    barcode = Barby::QrCode.new("https://tractrak.com#{text}", level: :q, size: 9)
    base64_output = Base64.encode64(barcode.to_png({ xdim: size }))
    "data:image/png;base64,#{Rack::Utils.escape(base64_output)}"
  end

  def ppl_process(file)
    if file.is_a?(String)
      path = 'temp.csv'
      File.write(path, file)
    end

    CSV.foreach(file.is_a?(String) ? path : file.path, headers: false) do |row|
      next if row[1].nil?

      # row will be an array containing the comma-separated elements of the line:
      # array(
      #   0 => AthleteId,
      #   1 => LastName
      #   2 => FirstName
      #   3 => Team
      #   4 => ?
      #   5 => Gender
      #   6 => Races (one is int, two+ is csv list in quotes ")
      #  )

      gender = row[5] == 'M' ? 0 : 1
      athlete = Athlete::finder(first_name: row[2], last_name: row[1], gender: gender, create: true)

      team = Team::finder(name: row[3], create: true)

      athlete.careers.where(team: team).first_or_create!(current: true)

      self.ppl = true
      save!
    end
  end

  def evt_process(file)
    if evt
      # We are handling a re-upload, so remove then reorder
      races_to_delete = races.all.to_a
      CSV.foreach(file.path, headers: false) do |row|
        unless row[0].nil?
          races_to_delete.delete_if do |r|
            (r.event == row[0] && r.round == row[1] && r.heat == row[2]) || r.has_results?
          end
        end
      end

      races_to_delete.each {|r| r.delete unless r.has_results? }
      reschedule
    end

    CSV.foreach(file.path, headers: false) do |row|
      #   Two types of rows depending on first value
      # 0 = Race
      # 1 = round
      # 2 = heat
      # 3 = Event Name
      # 4 = ?
      #
      # 9 = Distance in m
      #
      # 0 = blank
      # 1 = athlete ID (local)
      # 2 = lane assignment
      # 3 = LastName
      # 4 = FirstName
      # 5 = TeamName
      if !row[0].nil?
        @race = create_race(row)
        raise StandardError, "The file is not formatted properly: #{@race}" unless @race.is_a?(Race)

        # To avoid updating a race if it already has results
        return if @race.has_results?

        # Blank the heat if we are reprocessing
        if self.evt
          @race.competitors.delete_all
        end
      else
        if row[4].nil?
          # If 4 is empty, this is a team
          team_racer(row)
        else
          athlete_racer(row)
        end
      end
    end

    # Reschedule the order if new schedule since we may have added or deleted
    reschedule if self.evt
    self.evt = true
    save!
  end

  def sch_process(file)
    if file.is_a?(String)
      path = 'temp.csv'
      File.write(path, file)
    end

    CSV.foreach(file.is_a?(String) ? path : file.path, headers: false).with_index(0) do |row, order|
      # Handles comment lines, like the very first line
      next if row[1].nil?

      # 0 = event
      # 1 = round
      # 2 = heat

      Race.where(
        meet_id: self.id,
        event: row[0],
        round: row[1],
        heat: row[2]
      ).update({ schedule: order })
    end

    self.sch = true
    save!
  end

  def lif_file(file)
    ActiveRecord::Base.transaction do
      lanes_found = []

      if file.is_a?(String)
        path = 'temp.csv'
        File.write(path, file)
      end

      CSV.foreach(file.is_a?(String) ? path : file.path, headers: false).with_index(1) do |row, row_counter|
        if row_counter === 1
          # row will be an array containing the comma-separated elements of the line:
          # array(
          #   0: event_id,
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
            meet_id: self,
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

            team = Team::finder(name: row[3])

            lanes_found << row[2]
            lane = @race.competitors.find_by(lane: row[2])

            if lane.nil?
              # Lane doesn't exist, so let's just add it, likely better data
              lane = @race.competitors.new(team: team, lane: row[2])
            end

            # lane.team = team

            if row[0].present?
              lane.place = row[0]
            end

            if row[6].present?
              lane.result = ApplicationHelper.normalize_time(row[6])
            end

            if lane.save!
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
            athlete = Athlete::finder(first_name: row[4], last_name: row[3])

            lanes_found << row[2]
            lane = @race.competitors.find_by(lane: row[2])

            if lane.nil?
              # Lane doesn't exist, so let's just add it, likely better data
              team = Team::finder(name: row[5])
              lane = @race.competitors.new(athlete: athlete, team: team, lane: row[2])
            end

            # lane.athlete = athlete

            if row[0].present?
              lane.place = row[0]
            end

            if row[6].present?
              lane.result = ApplicationHelper.normalize_time(row[6])
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

      # delete any lanes not found in the csv
      @race.competitors.where.not(lane: lanes_found).delete_all

    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.debug(e)
    end

    if @event_id.nil? || @round_id.nil? || @heat_id.nil?
      Rails.logger.debug("Did not have event or round or heat: #{@event_id}|#{@round_id}|#{@heat_id}")
      return []
    end

    Rails.logger.debug("Successfully processed event|round|heat: #{@event_id}|#{@round_id}|#{@heat_id}")

    @race
  end

  def reschedule
    races.order(:event)
         .order(:round)
         .order(:heat)
         .each.with_index(1) do |race, index|
      race.schedule = index
      race.save!
    end
  end

  def completed_races_by_event(event)
    races
      .where(event: event)
      .includes(:competitors, :race_type)
      .where.not('competitors.result' => nil)
      .where.not('competitors.place' => %w[DNS FS DNF DQ SCR])
  end

  def number_of_athletes
    self.competitors.group_by(&:athlete_id).count
  end

  def number_of_teams
    self.competitors.group_by(&:team_id).count
  end

  def number_of_events
    self.races.group_by(&:event).count
  end

  def broadcast_meet
    # TODO
  end

  def broadcast_event(event)
    event.races.each { |r| broadcast_race(r) }
  end

  def broadcast_race(race)
    race.broadcast_replace_to "meet-#{self.id}",
      partial: 'meet/race',
      target: "meet-#{self.id}-race-#{race.id}",
      locals: { race: race }

    races = self.completed_races_by_event(race.event)
    if races.count > 1
      @race.broadcast_replace_to "meet-#{self.id}",
        partial: 'meet/event',
        target: "meet-#{self.id}-event-#{race.event}-combined",
        locals: { meet: self, races: races, event: race.event }
    end
  end

  private

  def create_race(row)
    gender = (row[3].downcase.include?('boy') || row[3].downcase.include?('men')) ? 0 : 1
    team_race = row[3].downcase.include?('relay') || row[3].downcase.include?('medley') ? 1 : 0
    race_type = RaceType.find_or_create_by!(name: row[3], gender: gender, athlete_team: team_race)

    Race.find_or_create_by!(
      meet: self,
      race_type: race_type,
      event: row[0],
      round: row[1],
      heat: row[2]
    )
  end

  def team_racer(row)
    team = Team::finder(name: row[3], create: true)

    Competitor.create!(team: team, race: @race, lane: row[2].to_i)
  end

  def athlete_racer(row)
    athlete = Athlete::finder(first_name: row[4], last_name: row[3], gender: @race.race_type.gender, create: true)

    team = Team::finder(name: row[5], create: true)
    athlete.set_current_team(team)

    Competitor.where(race: @race).where(lane: row[2].to_i).first_or_create!(athlete: athlete, team: team)
  end
end

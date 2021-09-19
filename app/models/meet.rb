require 'csv'

class Meet < ApplicationRecord
  # include Discard.Model

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :season, optional: true
  belongs_to :stadium, optional: true
  has_many :races

  def paid?
    true
    # paid === 1 # enable when paying is required
  end

  def ready?
    sch && evt && ppl && paid?
  end

  def qr(text)
    require 'barby'
    require 'barby/barcode'
    require 'barby/barcode/qr_code'
    require 'barby/outputter/png_outputter'
    barcode = Barby::QrCode.new(text, level: :q, size: 9)
    base64_output = Base64.encode64(barcode.to_png({ xdim: 5 }))
    "data:image/png;base64,#{Rack::Utils.escape(base64_output)}"
  end

  def ppl_process(file)
    CSV.foreach(file.path, headers: false) do |row|
      next if row[1].nil?

      # row will be an array containing the comma-separated elements of the line:
      # array(
      #   0 => AthleteId,
      #   1 => LastName
      #   2 => FirstName
      #   3 => Team
      #   4 => ?
      #   5 => Gender
      #   6 => Races (one is int, two is csv list in quotes ")
      #  )

      gender = row[5] == 'M' ? 0 : 1
      athlete = Athlete.finder(name: "#{row[2]} #{row[1]}", gender: gender, create: true)

      team = Team::finder(name: row[3], create: true)

      athlete.careers.where(team: team).first_or_create!(current: true)

      self.ppl = true
      save!
    end
  end

  def evt_process(file)
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
      else
        raise StandardError, "The file is not formatted properly: #{@race}" unless @race.is_a?(Race)

        if row[4].nil?
          # If 4 is empty, this is a team
          team_racer(row)
        else
          athlete_racer(row)
        end
      end
    end

    self.evt = true
    save!
  end

  def sch_process(file)
    CSV.foreach(file.path, headers: false).with_index(0) do |row, order|
      # Handles comment lines, like the very first line
      next if row[1].nil?

      # 0 = event
      # 1 = round
      # 2 = heat

      Race.where(
        id: id,
        event: row[0],
        round: row[1],
        heat: row[2]
      ).update({ schedule: order })
    end

    self.sch = true
    save!
  end

  private

  def create_race(row)
    gender = row[3].include?('Boys') ? 0 : 1
    team_race = row[3].include?('Relay') || row[3].include?('Medley') ? 1 : 0
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
    athlete = Athlete.finder(name: "#{row[4]} #{row[3]}", gender: @race.race_type.gender, create: true)

    team = Team::finder(name: row[5], create: true)
    athlete.set_current_team(team)

    Competitor.create!(athlete: athlete, race: @race, team: team, lane: row[2].to_i)
  end
end

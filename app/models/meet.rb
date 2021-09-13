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

  def qr
    # TODO
    #
    # $qrCode = new QrCode()
    # $qrCode.setWriterByName('png')
    # $qrCode.setText(URL.route('frontend.meet.live', ['id: $this.id]))
    # $qrCode.setSize(300)
    # $qrCode.setMargin(10)
    # $qrCode.setErrorCorrectionLevel(new ErrorCorrectionLevel(ErrorCorrectionLevel.HIGH))
    # $qrCode.setForegroundColor(['r: 0, 'g: 0, 'b: 0, 'a: 0])
    # $qrCode.setBackgroundColor(['r: 255, 'g: 255, 'b: 255, 'a: 0])
    # $qrCode.setLabel('TracTrak.com', 24)
    #
    # return $qrCode
  end

  def generate_pdf
    # TODO
    #
    # $pdf = PDF.loadView('flyer', [
    #   'meet: $this,
    #   'qr: $this.qr(),
    # ])
    #
    # return $pdf.download('TracTrak-meet-flyer.pdf')
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
      athlete = athlete_search("#{row[3]} #{row[4]}", gender)

      team = team_search(row[3])

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
    team = team_search(row[3])

    Competitor.create!(team: team, race: @race, lane: row[2])
  end

  def athlete_racer(row)
    athlete = athlete_search("#{row[3]} #{row[4]}", @race.race_type.gender)

    team = team_search(row[5])
    athlete.set_current_team(team)

    Competitor.create!(athlete: athlete, race: @race, lane: row[2])
  end

  def athlete_search(name, gender)
    # TODO: Add more search capability
    Athlete.find_or_create_by!(name: name, gender: gender)
  end

  def team_search(name)
    # TODO: Need to find teams better, filtering by state at least
    team = Team.find_or_create_by!(name: name)
    raise RuntimeException("Team id is zero: #{team.name}") if team.id.zero?

    return team unless team.new_record?

    team.abbr = name[0, 4]
    team.save!
    team
  end
end

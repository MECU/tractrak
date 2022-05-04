class Admin::ScrapeController < ApplicationController
  def scrape
    url = params['scrape']['url']
    url_split = url.split('/')
    state = State.find_by(abbr: url_split[2].split('.')[0].upcase)
    meet_id = url_split[4].split('-')[0]
    results_id = url_split[6]

    doc = JSON.load(URI.open("https://co.milesplit.com/api/v1/meets/#{meet_id}/performances?resultsId=#{results_id}&fields=id,meetId,meetName,teamId,videoId,teamName,athleteId,firstName,lastName,gender,genderName,divisionId,divisionName,ageGroupName,gradYear,eventName,eventCode,eventDistance,eventGenreOrder,round,roundName,heat,units,mark,place,windReading,profileUrl,teamProfileUrl, performanceVideoId&m=GET"))

    meet_name = doc['data'].first['meetName']
    meet = Meet.create_with(name: meet_name, owner_id: 1).find_or_create_by!(milesplit_id: meet_id.to_i)

    doc['data'].each do |result|
      process_result(meet: meet, r: result)
    end

    # assign place per heat
    meet.races.each do |race|
      race.competitors_sorted.each.with_index(1) do |c, index|
        c.place = index
        c.save!
      end
    end

    # assign event per race_type
    races = Race.where(meet: meet).group('race_type_id').count
    races.each.with_index(1) do |race, index|
      Race.where(meet: meet).where(race_types: race[0]).update(event: index, round: 1)
    end

    meet.reschedule

    meet.ppl = true
    meet.evt = true
    meet.sch = true
    meet.save!

    flash[:info] << 'Meet successfully scraped!'
  end

  private

  # id	"124382436"
  # eventCode	"100m"
  # gender	"F"
  # athleteId	"9248311"
  # teamId	"15093"
  # round	"f"
  # heat	"6"
  # place	"1"
  # windReading	"-4.1"
  # units	"12840"
  # teamName	"Valor Christian High School"
  # firstName	"Peyton"
  # lastName	"Holmes"
  # gradYear	"2023"
  # eventName	"100 Meter Dash"
  # eventDistance	"100"
  # ageGroupName	null
  # videoId	0
  # divisionId	null
  # divisionName	null
  # roundName	"Finals"
  # genderName	"Girls"
  # eventGenreOrder	1
  # profileUrl	"https://www.milesplit.co…es/9248311-peyton-holmes"
  # teamProfileUrl	"https://co.milesplit.com…or-christian-high-school"
  # performanceVideoId	null
  # mark	"12.84"
  def process_result(meet:, r:, state: State.find(6))
    race_type = RaceType.find_or_create_by!(name: "#{r['genderName']} #{r['eventName']}")
    if race_type.new_record?
      flash[:info] << "*** NEW RACE TYPE ***: #{r['genderName']} #{r['eventName']}"
    else
      unless race_type.parent.nil?
        race_type = RaceType.find!(race_type.parent)
      end
    end

    if race_type.athlete_race?
      athlete = Athlete.find_by(milesplit_id: r['athleteId'])
      if athlete.nil?
        athlete = Athlete.finder(first_name: r['firstName'], last_name: r['lastName'], gender: r['gender'] == 'F', create: true)
        athlete.milesplit_id = r['athleteId']
        athlete.save!
      end
    end

    team = Team.find_by(milesplit_id: r['teamId'])
    if team.nil?
      team = Team.finder(name: r['teamName'], state_id: state.id, create: true)
      team.milesplit_id = r['athleteId']
      team.save!
    end

    race = meet.races.find_or_create_by!(race_type: race_type, heat: r['heat'])
    if race.event.nil?
      race.schedule = meet.number_of_events
      race.wind = r['windReading'] if race_type.wind?
      race.save!
    end

    time = ApplicationHelper.normalize_time(r['mark'])
    if race_type.athlete_race?
      race.competitors.create!(athlete: athlete, team: team, result: time)
    else
      race.competitors.create!(team: team, result: time)
    end
  end

  def create_athlete(result) end
end

class AdminController < ApplicationController
  # before_action :authenticate_user!

  def index

  end

  def scrape(params)
    url = params["url"]
    url_split = url.split('/')
    meet_id = url_split[4].split('-')[0]
    results_id = url_split[6]
    meet = Meet.create_with(name: params['name']).find_or_create_by(milesplit_id: meet_id)
    doc = JSON.load(URI.open("https://co.milesplit.com/api/v1/meets/#{meet_id}/performances?resultsId=#{results_id}&fields=id%2CteamId%2CteamName%2CathleteId%2CfirstName%2ClastName%2Cgender%2CgenderName%2CdivisionId%2CdivisionName%2CageGroupName%2CgradYear%2CeventName%2CeventCode%2CeventDistance%2CeventGenreOrder%2Cround%2CroundName%2Cheat%2Cunits%2Cmark%2Cplace%2CwindReading%2CprofileUrl%2CteamProfileUrl&m=GET"))

    doc['data'].each do |result|
      process_result(meet: meet, r: result)
    end
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
  def process_result(meet:, r:)
    athlete = Athlete.find_by(milesplit_id: r['athleteId'])
    athlete = Athlete.finder(first_name: r['firstName'], last_name: r['lastName'], gender: r['gender'] == 'F', create: true) if athlete.nil?

    team = Team.finder(name: r['teamName'], create: true)
  end

  def create_athlete(result) end
end

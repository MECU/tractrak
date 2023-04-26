module Broadcast
  def broadcast_race(meet:, race:)
    @meet = meet
    @race = race
    race.broadcast_replace_to "meet-#{meet.id}",
      partial: 'meet/race',
      target: "meet-#{meet.id}-race-#{race.id}",
      locals: { race: }

    races = meet.completed_races_by_event(race.event)
    if races.count > 1
      race.broadcast_replace_to "meet-#{meet.id}",
        partial: 'meet/event',
        target: "meet-#{meet.id}-event-#{race.event}-combined",
        locals: { meet:, races:, event: race.event }
    end
  end
end
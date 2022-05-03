ActiveAdmin.register RaceType do
  permit_params :name, :gender, :athlete_team, :track_field, :wind, :discarded_at
end

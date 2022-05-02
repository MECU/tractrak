ActiveAdmin.register RaceType do
  permit_params :name, :gender, :athlete_team, :discarded_at, :wind
end

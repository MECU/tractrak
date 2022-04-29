ActiveAdmin.register Meet do
  filter :name
  filter :meet_date
  filter :owner

  index do
    id_column
    column :name
    column :meet_date
    column :owner
    actions
  end

  permit_params :paid, :name, :owner_id, :meet_date, :season_id, :stadium_id, :points, :sponsor, :time_zone, :ppl, :evt, :sch, :discarded_at
end

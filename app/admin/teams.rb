ActiveAdmin.register Team do
  filter :name
  filter :abbr
  filter :state
  filter :country

  index do
    id_column
    column :name
    column :abbr
    column :state
    column :country
    actions
  end

  form do |f|
    f.input :name
    f.input :abbr
    f.input :state
    f.actions
  end

  permit_params :name, :abbr, :state_id
end

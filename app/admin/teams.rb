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
    label :state
    f.collection_select :state_id, State.all, :id, :name
    f.actions
  end

  permit_params :name, :abbr, :state_id
end

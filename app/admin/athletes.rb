ActiveAdmin.register Athlete do
  filter :first_name
  filter :last_name
  filter :gender, as: :boolean

  index do
    para '0=male, 1=female'
    id_column
    column :first_name
    column :last_name
    column :gender
    actions
  end

  permit_params :first_name, :last_name, :height, :gender, :weight, :userid
end

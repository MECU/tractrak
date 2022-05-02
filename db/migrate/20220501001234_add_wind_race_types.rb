class AddWindRaceTypes < ActiveRecord::Migration[7.0]
  def up
    add_column :race_types, :wind, :boolean, default: false
  end

  def down
    remove_column :race_types, :wind
  end
end

class AddTrackFieldToRaceTypes < ActiveRecord::Migration[7.0]
  def up
    add_column :race_types, :track_field, :boolean, default: false
  end

  def down
     remove_column :race_types, :track_field, :boolean
  end
end

class AddParentToRaceTypes < ActiveRecord::Migration[7.0]
  def up
    add_column :race_types, :parent, :int, default: nil, :null => true
  end

  def down
     remove_column :race_types, :parent
  end
end

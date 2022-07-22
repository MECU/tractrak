class AlterIndexOnRaceType < ActiveRecord::Migration[7.0]
  def up
    add_index :race_types, [:name, :gender], unique: true
    remove_index :race_types, :name
  end

  def down
    add_index :race_types, [:name], unique: true
    remove_index :race_types, [:name, :gender]
  end
end

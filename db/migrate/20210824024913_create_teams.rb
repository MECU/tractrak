class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name, index: true
      t.string :abbr, null: true
      t.boolean :state_id, null: true
      t.integer :country_id, null: true
      t.timestamps
      t.datetime :discard, index: true
    end
  end
end

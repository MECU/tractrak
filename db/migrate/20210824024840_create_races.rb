class CreateRaces < ActiveRecord::Migration[6.0]
  def change
    create_table :races do |t|
      t.integer :meet_id, index: true
      t.integer :race_type, index: true
      t.boolean :schedule
      t.boolean :event
      t.boolean :round
      t.boolean :heat
      t.time :start, null: true
      t.decimal :wind, default: nil, null: true, :precision => 4, :scale => 1
      t.timestamps
      t.datetime :discard, index: true
    end

    add_index :races, [:meet_id, :event, :round, :heat], unique: true, name: 'meet_event_round_heat'
  end
end

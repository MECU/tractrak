class CreateRaces < ActiveRecord::Migration[6.0]
  def change
    create_table :races do |t|
      t.integer :meet_id, index: true
      t.integer :race_type_id, index: true
      t.integer :schedule
      t.integer :event
      t.integer :round
      t.integer :heat
      t.time :start, null: true
      t.decimal :wind, default: nil, null: true, :precision => 4, :scale => 2
      t.datetime :discard, index: true
      t.timestamps
    end

    add_index :races, [:meet_id, :event, :round, :heat], unique: true, name: 'meet_event_round_heat'
  end
end

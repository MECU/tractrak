class CreateMeets < ActiveRecord::Migration[6.0]
  def change
    create_table :meets do |t|
      t.boolean :paid, null: true
      t.string :name
      t.integer :owner_id, index: true
      t.datetime :meet_date
      t.integer :season_id
      t.integer :stadium_id, null: true
      t.jsonb :points, null: true
      t.string :sponsor, null: true
      t.integer :milesplit_id, :unsigned => true
      t.string :time_zone
      t.boolean :ppl, default: 0
      t.boolean :evt, default: 0
      t.boolean :sch, default: 0
      t.string :meet_key, null: true, index: { unique: true }, length: 32
      t.datetime :discard, index: true
      t.timestamps
    end
  end
end

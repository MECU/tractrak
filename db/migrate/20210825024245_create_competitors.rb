class CreateCompetitors < ActiveRecord::Migration[6.0]
  def change
    create_table :competitors do |t|
      t.integer :race_id, index: true
      t.integer :athlete_id, index: true, null: true
      t.integer :team_id, index: true, null: true
      t.boolean :lane, index: true
      t.string :result, null: true
      t.string :seed, null: true
      t.string :place, null: true, index: true
    end
  end
end

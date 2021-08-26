class CreateRaceTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :race_types do |t|
      t.string :name, index: { unique: true }
      t.boolean :gender, default: 0 # 0=male, 1=female
      t.boolean :athlete_team, default: 0 # 0=athlete, 1=team
      t.timestamps
      t.datetime :discard, index: true
    end
  end
end

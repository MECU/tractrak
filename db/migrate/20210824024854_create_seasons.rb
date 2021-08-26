class CreateSeasons < ActiveRecord::Migration[6.0]
  def change
    create_table :seasons do |t|
      t.date :season
      t.integer :state_id
      t.integer :country_id
      t.integer :classification_id
      t.integer :level_id
      t.timestamps
      t.datetime :discard, index: true
    end
  end
end

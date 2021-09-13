class CreateCareers < ActiveRecord::Migration[6.0]
  def change
    create_table :careers do |t|
      t.integer :athlete_id, index: true
      t.integer :team_id, index: true
      t.boolean :current
      t.timestamps
      t.datetime :discard, index: true
    end
  end
end

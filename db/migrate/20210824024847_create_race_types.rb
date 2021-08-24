class CreateRaceTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :race_types do |t|

      t.timestamps
    end
  end
end

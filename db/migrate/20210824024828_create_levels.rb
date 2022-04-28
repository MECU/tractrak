class CreateLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :levels do |t|
      t.string :name
      t.string :abbr
      t.datetime :discard, index: true
      t.timestamps
    end
  end
end

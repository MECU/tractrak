class CreateLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :levels do |t|
      t.string :name
      t.string :abbr
      t.timestamps
      t.datetime :discard, index: true
    end
  end
end

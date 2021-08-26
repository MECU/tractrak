class CreateStates < ActiveRecord::Migration[6.0]
  def change
    create_table :states do |t|
      t.string :name
      t.string :abbr, length: 2
      t.string :timezone
      t.integer :country_id
      t.decimal :lat, :precision => 11, :scale => 7
      t.decimal :lng, :precision => 11, :scale => 7
      t.timestamps
      t.datetime :discard, index: true
    end
  end
end

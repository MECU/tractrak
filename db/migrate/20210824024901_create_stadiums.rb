class CreateStadiums < ActiveRecord::Migration[6.0]
  def change
    create_table :stadiums do |t|
      t.string :name
      t.string :google_name, null: true
      t.text :address, null: true
      t.string :city, null: true
      t.integer :state_id
      t.integer :zip, null: true
      t.integer :country_id
      t.decimal :lat, null: true, :precision => 11, :scale => 7
      t.decimal :lng, null: true, :precision => 11, :scale => 7
      t.datetime :discard, index: true
      t.timestamps
    end
  end
end

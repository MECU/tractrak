class CreateAthletes < ActiveRecord::Migration[6.0]
  def change
    create_table :athletes do |t|
      t.string :name
      t.integer :height, null: true
      t.boolean :gender, index: true # 0=men, 1=women
      t.integer :weight, null: true
      t.integer :userid, null: true
      t.timestamps
      t.datetime :discard, index: true
    end
  end
end

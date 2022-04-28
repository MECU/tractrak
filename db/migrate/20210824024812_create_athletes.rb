class CreateAthletes < ActiveRecord::Migration[6.0]
  def change
    create_table :athletes do |t|
      t.string :first_name, index: true
      t.string :last_name, index: true
      t.integer :height, null: true
      t.boolean :gender, index: true # 0=men, 1=women
      t.integer :weight, null: true
      t.integer :userid, null: true
      t.datetime :discard, index: true
      t.timestamps
    end
  end
end

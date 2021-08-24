class CreateAthletes < ActiveRecord::Migration[6.0]
  def change
    create_table :athletes do |t|

      t.timestamps
    end
  end
end

class AddEndDateToMeet < ActiveRecord::Migration[7.0]
  def up
    add_column :meets, :meet_end_date, :datetime, null: true
  end

  def down
    remove_column :meets, :meet_end_date
  end
end

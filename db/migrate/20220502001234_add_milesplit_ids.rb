class AddMilesplitIds < ActiveRecord::Migration[7.0]
  def up
    add_column :athletes, :milesplit_id, :integer
    add_column :teams, :milesplit_id, :integer
  end

  def down
    remove_column :athletes, :milesplit_id
    remove_column :teams, :milesplit_id
  end
end

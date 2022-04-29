class AlterTeamsStateBooleanToInt < ActiveRecord::Migration[7.0]
  def change
    change_column :teams, :state_id, :integer, using: 'state_id::integer'
  end
end

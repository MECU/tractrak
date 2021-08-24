class CreateMeets < ActiveRecord::Migration[6.0]
  def change
    create_table :meets do |t|

      t.timestamps
    end
  end
end

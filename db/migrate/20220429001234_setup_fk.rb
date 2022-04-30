class SetupFk < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :races, :meets, on_delete: :cascade
    add_foreign_key :competitors, :races, on_delete: :cascade
  end
end

class AlterDiscardToDiscardedAt < ActiveRecord::Migration[7.0]
  def self.up
    rename_column :athletes, :discard, :discarded_at
    rename_column :teams, :discard, :discarded_at
    rename_column :levels, :discard, :discarded_at
    rename_column :meets, :discard, :discarded_at
    rename_column :races, :discard, :discarded_at
    rename_column :race_types, :discard, :discarded_at
    rename_column :seasons, :discard, :discarded_at
    rename_column :stadiums, :discard, :discarded_at
    rename_column :careers, :discard, :discarded_at
    rename_column :states, :discard, :discarded_at
  end

  def self.down
    rename_column :athletes, :discarded_at, :discard
    rename_column :teams, :discarded_at, :discard
    rename_column :levels, :discarded_at, :discard
    rename_column :meets, :discarded_at, :discard
    rename_column :races, :discarded_at, :discard
    rename_column :race_types, :discarded_at, :discard
    rename_column :seasons, :discarded_at, :discard
    rename_column :stadiums, :discarded_at, :discard
    rename_column :careers, :discarded_at, :discard
    rename_column :states, :discarded_at, :discard
  end
end

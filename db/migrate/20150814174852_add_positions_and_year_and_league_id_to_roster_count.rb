class AddPositionsAndYearAndLeagueIdToRosterCount < ActiveRecord::Migration
  def change
    add_column :roster_counts, :league_id, :integer
    add_column :roster_counts, :year, :integer
    add_column :roster_counts, :dt, :integer
    add_column :roster_counts, :de, :integer
    add_column :roster_counts, :cb, :integer
    add_column :roster_counts, :s, :integer
    add_index :roster_counts, [:league_id, :year], :unique => true
    remove_column :leagues, :roster_count_id
  end
end

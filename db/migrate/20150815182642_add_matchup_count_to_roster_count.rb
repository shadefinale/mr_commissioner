class AddMatchupCountToRosterCount < ActiveRecord::Migration
  def change
    add_column :roster_counts, :matchup_count, :integer
  end
end

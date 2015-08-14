class AddFlexToRosterCounts < ActiveRecord::Migration
  def change
    add_column :roster_counts, :flex, :integer
  end
end

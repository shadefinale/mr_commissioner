class AddEspnidToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :espn_id, :integer
  end
end

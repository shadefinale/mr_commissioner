class ChangeTeamNameColumnToName < ActiveRecord::Migration
  def change
    rename_column :teams, :team_name, :name
  end
end

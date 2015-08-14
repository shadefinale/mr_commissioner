class ChangeLeaguesColumnOnTeams < ActiveRecord::Migration
  def change
    rename_column :teams, :leagues, :league_id
  end
end

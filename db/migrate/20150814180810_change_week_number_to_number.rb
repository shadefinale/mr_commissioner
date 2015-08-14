class ChangeWeekNumberToNumber < ActiveRecord::Migration
  def change
    rename_column :weeks, :week_number, :number
    remove_column :player_scores, :teams
    add_column :player_scores, :team_id, :integer
  end
end

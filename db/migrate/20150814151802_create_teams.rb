class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :team_name
      t.integer :league_id, index: true, foreign_key: true
    end
  end
end

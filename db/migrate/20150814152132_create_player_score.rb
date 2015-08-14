class CreatePlayerScore < ActiveRecord::Migration
  def change
    create_table :player_scores do |t|
      t.integer :teams, foreign_key: true
      t.integer :player_id
      t.integer :week_id
      t.decimal :points, precision: 5, scale: 2
      t.boolean :starter
    end
  end
end

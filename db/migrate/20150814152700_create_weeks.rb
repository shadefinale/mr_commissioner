class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.integer :year
      t.integer :week_number
    end

    add_foreign_key :player_scores, :weeks
  end
end

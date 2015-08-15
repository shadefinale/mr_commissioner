class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :team_id
      t.integer :year
      t.integer :wins
      t.integer :losses
      t.integer :ties

      t.timestamps null: false
    end
  end
end

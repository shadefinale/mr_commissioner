class Userjoinleagues < ActiveRecord::Migration
  def change
    create_join_table :users, :leagues do |t|
      t.index :user_id
      t.index :league_id
    end
  end
end

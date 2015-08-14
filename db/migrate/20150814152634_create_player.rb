class CreatePlayer < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :postiion
    end
    
    add_foreign_key :player_scores, :players
  end
end

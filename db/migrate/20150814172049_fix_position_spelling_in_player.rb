class FixPositionSpellingInPlayer < ActiveRecord::Migration
  def change
    rename_column :players, :postiion, :position
  end
end

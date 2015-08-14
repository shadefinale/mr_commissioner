class CreateRosterCounts < ActiveRecord::Migration
  def change
    create_table :roster_counts do |t|
      t.integer :qb
      t.integer :rb
      t.integer :wr
      t.integer :te
      t.integer :k
      t.integer :d_st
      t.integer :lb
      t.integer :dl
      t.integer :db
    end

    add_foreign_key :leagues, :roster_counts
  end
end

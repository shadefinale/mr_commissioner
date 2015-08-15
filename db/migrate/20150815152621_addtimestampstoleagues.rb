class Addtimestampstoleagues < ActiveRecord::Migration
  def change
    add_timestamps(:leagues)
  end
end

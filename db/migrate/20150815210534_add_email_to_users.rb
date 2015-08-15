class AddEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string, unique: true, null: false
  end
end

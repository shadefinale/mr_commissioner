class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :username, null: false, unique: true
      t.string :password_digest, null: false

      t.timestamps null: false
    end

    add_column :users, :auth_token, :string
    add_index :users, :auth_token, unique: true
  end
end

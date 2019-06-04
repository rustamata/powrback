class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :login
      t.text :user_info
    end
    add_index :users, [:login]
  end
end
class AddPasswordEncrytion < ActiveRecord::Migration
  def self.up
    remove_column :users, :password
    add_column :users, :salt, :string
    add_column :users, :encrypted_password, :string
  end

  def self.down
    remove_column :users, :encrypted_password
    remove_column :users, :salt
    add_column :users, :password, :string
  end
end

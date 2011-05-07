class UserBalance < ActiveRecord::Migration
  def self.up
    add_column :users, :balance, :float, :null => false, :default => 0.00
  end

  def self.down
    remove_column :users, :balance
  end
end

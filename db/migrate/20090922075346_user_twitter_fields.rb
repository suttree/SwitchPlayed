class UserTwitterFields < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_name, :string
    add_column :users, :twitter_screen_name, :string
    add_column :users, :signup_source, :string
  end

  def self.down
    remove_column :users, :twitter_name
    remove_column :users, :twitter_screen_name
    remove_column :users, :signup_source
  end
end

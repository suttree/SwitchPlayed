class AddScoretoGame < ActiveRecord::Migration
  def self.up
    add_column :games, :score, :string, :default => "0 - 0"
  end

  def self.down
    remove_column :games, :score
  end
end

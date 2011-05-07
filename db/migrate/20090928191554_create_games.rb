class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :pip, :null => false, :limit => 5
      t.string :home_team, :null => false
      t.string :away_team, :null => false
      t.datetime :start_time, :null => false
      t.datetime :end_time, :null => false
      t.timestamps
    end

    add_index :games, :pip
  end

  def self.down
    drop_table :games
  end
end

class CreateScores < ActiveRecord::Migration
  def self.up
    create_table :scores do |t|
      t.integer :game_id, :null => false
      t.string :home_team, :null => false, :default => 0
      t.string :away_team, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :scores
  end
end

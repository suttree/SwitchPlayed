class CreateBets < ActiveRecord::Migration
  def self.up
    create_table :bets do |t|
      t.integer :user_id, :null => false
      t.integer :game_id, :null => false
      t.float :amount, :null => false
      t.string :period, :null => false
      t.string :remote_ip, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :bets
  end
end

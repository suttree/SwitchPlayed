class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :user_id, :null => false
      t.integer :amount, :null => false
      t.string :status, :null => false
      t.integer :game_id, :null => true
      t.string :session_id, :null => true
      t.string :remote_ip, :null => true
      t.timestamps
    end

    add_index :transactions, [:user_id, :status]
  end

  def self.down
    drop_table :transactions
  end
end

class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :user_id, :null => false
      t.integer :game_id, :null => false
      t.string :session_id, :null => false
      t.string :status, :null => false
      t.string :remote_ip, :null => false
      t.timestamps
    end

    add_index :activities, [:user_id, :status]
  end

  def self.down
    drop_table :activities
  end
end

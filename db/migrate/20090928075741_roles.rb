class Roles < ActiveRecord::Migration
  def self.up
    Role.reset_column_information
    Role.create(:name => 'admin')
  end

  def self.down
    Role.all do |r|
      r.destroy
    end
  end
end

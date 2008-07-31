class AddHitsAndComms < ActiveRecord::Migration
  def self.up
    add_column :problems, :hit, :integer, :default => 0
    add_column :problems, :comment, :integer, :default => 0
  end

  def self.down
    remove_column :problems, :hit
    remove_column :problems, :comment
  end
end

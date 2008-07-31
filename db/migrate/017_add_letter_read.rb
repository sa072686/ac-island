class AddLetterRead < ActiveRecord::Migration
  def self.up
    add_column :letters, :read, :boolean
  end

  def self.down
    remove_column :letters, :read
  end
end

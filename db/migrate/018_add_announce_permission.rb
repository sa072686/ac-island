class AddAnnouncePermission < ActiveRecord::Migration
  def self.up
    add_column :permissions, :announce, :boolean
  end

  def self.down
    remove_column :permissions, :announce
  end
end

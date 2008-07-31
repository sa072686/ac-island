class ChangeMenu < ActiveRecord::Migration
  def self.up
    add_column :menus, :order, :integer
  end

  def self.down
    remove_column :menus, :order
  end
end

class AddOrderInCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :order, :integer
  end

  def self.down
    remove_column :categories, :order
  end
end

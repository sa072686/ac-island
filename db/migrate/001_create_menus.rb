class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.column :title, :string
      t.column :url, :string
      t.column :parent, :integer
    end
  end

  def self.down
    drop_table :menus
  end
end

class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :title, :string
      t.column :parent, :string
    end
  end

  def self.down
    drop_table :categories
  end
end

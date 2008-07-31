class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.column :title, :string
      t.column :type, :string
      t.column :note, :text
      t.column :url, :string
      t.column :order, :integer
    end
  end

  def self.down
    drop_table :links
  end
end

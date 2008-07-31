class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :content, :text
      t.column :author, :integer
      t.column :parent, :integer
      t.column :time, :datetime
    end
  end

  def self.down
    drop_table :comments
  end
end

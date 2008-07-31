class CreateDiaries < ActiveRecord::Migration
  def self.up
    create_table :diaries do |t|
      t.column :title, :string
      t.column :content, :text
      t.column :date, :datetime
      t.column :parent, :string
      t.column :author, :integer
    end
  end

  def self.down
    drop_table :diaries
  end
end

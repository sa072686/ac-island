class CreateLetters < ActiveRecord::Migration
  def self.up
    create_table :letters do |t|
      t.column :title, :string
      t.column :content, :text
      t.column :author, :integer
      t.column :receiver, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :letters
  end
end

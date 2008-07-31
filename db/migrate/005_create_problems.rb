class CreateProblems < ActiveRecord::Migration
  def self.up
    create_table :problems do |t|
      t.column :probid, :string
      t.column :title, :string
      t.column :author, :string
      t.column :difficulty, :integer
      t.column :category, :string
      t.column :modifydate, :datetime
      t.column :content, :text
      t.column :hint, :text
      t.column :solution, :text
      t.column :article, :text
      t.column :problem, :text
    end
  end

  def self.down
    drop_table :problems
  end
end

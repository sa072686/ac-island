class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.column :class, :string
      t.column :title, :string
      t.column :content, :text
      t.column :author, :string
      t.column :hit, :integer
      t.column :comment, :integer
      t.column :bookmark, :integer
      t.column :category, :integer
      t.column :updates_at, :datetime
      t.column :related_article, :text
      t.column :related_problem, :text
    end
  end

  def self.down
    drop_table :articles
  end
end

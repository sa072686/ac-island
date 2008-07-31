class ChangeToLongtext < ActiveRecord::Migration
  def self.up
    change_column :problems, :content, :text
  end

  def self.down
    change_column :problems, :content, :text
  end
end

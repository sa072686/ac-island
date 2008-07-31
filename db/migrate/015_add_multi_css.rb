class AddMultiCss < ActiveRecord::Migration
  def self.up
    add_column :users, :css, :string
  end

  def self.down
    remove_column :users, :css, :string
  end
end

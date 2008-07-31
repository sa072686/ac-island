class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.column :title, :string
      t.column :post, :boolean
      t.column :edit, :boolean
      t.column :delete, :boolean
      t.column :comment, :boolean
      t.column :god, :boolean
    end
  end

  def self.down
    drop_table :permissions
  end
end

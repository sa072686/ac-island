class CreateCsses < ActiveRecord::Migration
  def self.up
    create_table :csses do |t|
      t.column :name, :string
      t.column :fname, :string
    end
  end

  def self.down
    drop_table :csses
  end
end

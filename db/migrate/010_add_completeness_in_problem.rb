class AddCompletenessInProblem < ActiveRecord::Migration
  def self.up
    add_column :problems, :completeness, :string
  end

  def self.down
    remove_column :problems, :completeness
  end
end

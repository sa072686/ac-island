class Css < ActiveRecord::Base

  validates_presence_of :name, :fname
  validates_uniqueness_of :name, :fname
  validates_format_of :fname, :with => /^[a-zA-Z0-9_]+$/

end

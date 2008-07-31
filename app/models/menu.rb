class Menu < ActiveRecord::Base

  validates_presence_of :title, :url, :parent
  validates_numericality_of :parent, :order

end

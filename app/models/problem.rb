class Problem < ActiveRecord::Base

  validates_presence_of :probid, :title, :category, :completeness
  validates_numericality_of :difficulty

end

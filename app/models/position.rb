class Position < ActiveRecord::Base
  POSITIONS = %w{GK SW CB LB RB DM CM LM RM AM CF SS LF RF}
  #POSITIONS =    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12,13,14]
  
  validates_inclusion_of :label, :in => POSITIONS
end

class Position < ActiveRecord::Base
  POSITIONS = %w{GK SW CB LB RB DM CM LM RM AM CF SS}
  
  validates_inclusion_of :label, :in => POSITIONS
end

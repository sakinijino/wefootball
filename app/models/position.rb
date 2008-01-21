class Position < ActiveRecord::Base
  belongs_to :user
  
  validates_inclusion_of :label, :in => %w{GK SW CB LB RB DM CM LM RM AM CF SS}
end

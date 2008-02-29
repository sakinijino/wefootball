class MatchInvitation < ActiveRecord::Base
  MATCH_TYPES = [1,2]
  MATCH_SIZES = (5..11).to_a
  WIN_RULES = [1,2,3]
  
  validates_inclusion_of :match_type, :in => MATCH_TYPES
  validates_inclusion_of :size, :in => MATCH_SIZES
  validates_inclusion_of :win_rule, :in => WIN_RULES  
end

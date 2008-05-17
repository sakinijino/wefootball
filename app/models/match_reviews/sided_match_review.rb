class SidedMatchReview < MatchReview
  belongs_to :match, :class_name => "SidedMatch", :foreign_key => :match_id
end

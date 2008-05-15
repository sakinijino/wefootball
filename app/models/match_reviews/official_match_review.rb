class OfficialMatchReview < MatchReview
  belongs_to :match, :class_name => "OfficialMatch", :foreign_key => :match_id
end

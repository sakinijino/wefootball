class MatchReviewRecommendationBroadcast < Broadcast
  belongs_to :match_review, :class_name=>"MatchReview", :foreign_key=>"activity_id"
  
  def activity
    match_review_recommendation
  end
end

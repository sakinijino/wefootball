class MatchReviewCreationBroadcast < Broadcast
  belongs_to :match_review, :class_name=>"MatchReview", :foreign_key=>"activity_id"
  belongs_to :user
  def activity
    match_review
  end
end

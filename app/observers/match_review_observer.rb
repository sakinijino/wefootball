class MatchReviewObserver < ActiveRecord::Observer
  def after_create(match_review)
    MatchReviewCreationBroadcast.create!(:user_id=>match_review.user_id,
                                 :activity_id=>match_review.id)
  end 
end

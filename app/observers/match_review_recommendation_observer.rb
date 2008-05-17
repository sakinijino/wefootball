class MatchReviewRecommendationObserver < ActiveRecord::Observer
  def after_save(match_review_recommendation)
    if match_review_recommendation.status == 1
      MatchReviewRecommendationBroadcast.create!(:user_id=>match_review_recommendation.user_id,
                                   :activity_id=>match_review_recommendation.match_review_id)
    end
  end 
end

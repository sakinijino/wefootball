require File.dirname(__FILE__) + '/../test_helper'

class MatchReviewRecommendationTest < ActiveSupport::TestCase
  
  def test_user_cascade_destroy
    assert_difference 'User.count', -1 do
    assert_difference 'MatchReviewRecommendation.count', -1 do
      users(:mike1).destroy
    end
    end
  end 
  
  def test_match_review_cascade_destroy
    assert_difference 'MatchReview.count', -1 do
    assert_difference 'MatchReviewRecommendation.count', -1 do
      match_reviews(:saki_1).destroy
    end
    end
  end   
end

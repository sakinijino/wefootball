require File.dirname(__FILE__) + '/../test_helper'

class MatchReviewTest < ActiveSupport::TestCase
  def test_modify
    assert match_reviews(:saki_1).can_be_modified_by?(users(:saki))
    assert !match_reviews(:saki_1).can_be_modified_by?(users(:quentin))
  end
  
  def test_can_destroy
    assert match_reviews(:saki_1).can_be_destroyed_by?(users(:saki))
    assert !match_reviews(:saki_1).can_be_destroyed_by?(users(:mike1))
  end
  
  def test_reply_destroy
    assert_difference 'MatchReviewReply.count', -1 do
      match_reviews(:saki_1).destroy
    end
  end
  
  def test_user_destroy
    assert_difference 'MatchReview.count', -3 do
      users(:saki).destroy
    end
  end
  
  def test_match_destroy
    assert_difference 'MatchReview.count', -1 do
    assert_difference 'BiMatchReview.count', -1 do
      matches(:one).destroy
    end
    end
    
    assert_difference 'MatchReview.count', -1 do
    assert_difference 'SidedMatchReview.count', -1 do
      sided_matches(:one).destroy
    end
    end
    
    assert_difference 'MatchReview.count', -1 do
    assert_difference 'OfficialMatchReview.count', -1 do
      official_matches(:one).destroy
    end
    end
  end
  
  def test_like_by
    MatchReviewRecommendation.destroy_all
    
    mrr = MatchReviewRecommendation.new
    mrr.user_id = users(:saki).id
    mrr.match_review_id = match_reviews(:saki_1).id
    mrr.status = 1
    mrr.save!
    mrr = MatchReviewRecommendation.new
    mrr.user_id = users(:mike1).id
    mrr.match_review_id = match_reviews(:saki_1).id
    mrr.status = 0
    mrr.save!
    assert match_reviews(:saki_1).like_by?(users(:saki))
    assert !match_reviews(:saki_1).like_by?(users(:mike1))
    assert !match_reviews(:saki_1).like_by?(users(:aaron))
    assert !match_reviews(:saki_1).dislike_by?(users(:saki))
    assert match_reviews(:saki_1).dislike_by?(users(:mike1))
    assert !match_reviews(:saki_1).dislike_by?(users(:aaron))
  end
end

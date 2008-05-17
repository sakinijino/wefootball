require File.dirname(__FILE__) + '/../test_helper'

class MatchReviewReplyTest < ActiveSupport::TestCase
  def test_destroy
    assert match_review_replies(:quentin_1_reply).can_be_destroyed_by?(users(:quentin))
    assert match_review_replies(:quentin_1_reply).can_be_destroyed_by?(users(:saki))
    assert !match_review_replies(:quentin_1_reply).can_be_destroyed_by?(users(:mike1))
  end
  
  def test_replies_counter
    match_reviews(:saki_1).match_review_replies(:refresh).size
    r = MatchReviewReply.new(:content => "Test Reply")
    r.user = users(:saki)
    assert_difference "match_reviews(:saki_1).match_review_replies.size" do
      match_reviews(:saki_1).match_review_replies << r
      r.save!
    end
    
    assert_difference "MatchReviewReply.count", -1 do
    assert_difference "match_reviews(:saki_1).match_review_replies.size", -1 do
      match_reviews(:saki_1).match_review_replies.delete(r)
    end
    end
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class ReplyTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_destroy
    assert replies(:quentin_1_reply).can_be_destroyed_by?(users(:quentin))
    assert replies(:quentin_1_reply).can_be_destroyed_by?(users(:saki))
    assert !replies(:quentin_1_reply).can_be_destroyed_by?(users(:aaron))
  end
  
  def test_before_save
    r = Reply.new(:content => "Test Reply")
    r.post = posts(:saki_1)
    r.user = users(:saki)
    r.save
    assert_equal posts(:saki_1).team, r.team
  end
  
  def test_replies_counter
    posts(:saki_1).replies(:refresh).size
    r = Reply.new(:content => "Test Reply")
    r.user = users(:saki)
    assert_difference "posts(:saki_1).replies.size" do
      posts(:saki_1).replies << r
      r.save
    end
    
    assert_difference "Reply.count", -1 do
    assert_difference "posts(:saki_1).replies.size", -1 do
      posts(:saki_1).replies.delete(r)
    end
    end
  end
end

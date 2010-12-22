require File.dirname(__FILE__) + '/../test_helper'

class ReplyTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_destroy
    assert replies(:quentin_1_reply).can_be_destroyed_by?(users(:quentin))
    assert replies(:quentin_1_reply).can_be_destroyed_by?(users(:saki))
    assert !replies(:quentin_1_reply).can_be_destroyed_by?(users(:aaron))
    
    #reply of watch_post
    assert replies(:quentin_2_reply).can_be_destroyed_by?(users(:quentin))
    assert replies(:quentin_2_reply).can_be_destroyed_by?(users(:saki))
    assert !replies(:quentin_2_reply).can_be_destroyed_by?(users(:aaron))
  end
  
  def test_replies_counter
    posts(:saki_1).replies(:refresh).size
    r = Reply.new(:content => "Test Reply")
    r.user = users(:saki)
    assert_difference "posts(:saki_1).reload.replies.size" do
      posts(:saki_1).replies << r
      posts(:saki_1).save!
    end
    
    assert_difference "Reply.count", -1 do
    assert_difference "posts(:saki_1).reload.replies.size", -1 do
      posts(:saki_1).replies.delete(r)
    end
    end
  end

  def test_updated
    posts(:saki_1).updated_at = Time.now
    posts(:saki_1).save

    r = Reply.new(:content => "Test Reply")
    r.user = users(:saki)
    r.save

    r.post = posts(:saki_1)
    c_time = Time.now
    sleep(1)
    r.save 
    assert posts(:saki_1).reload.updated_at > c_time, "Reply save"

    r = Reply.new(:content => "Test Reply")
    r.user = users(:saki)
    c_time = Time.now
    sleep(1)
    posts(:saki_1).replies << r
    posts(:saki_1).save!
    assert posts(:saki_1).reload.updated_at > c_time, "Post << op save"
  end
end

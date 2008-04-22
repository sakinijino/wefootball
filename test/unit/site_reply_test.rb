require File.dirname(__FILE__) + '/../test_helper'

class SiteReplyTest < ActiveSupport::TestCase
  def test_destroy
    assert !site_replies(:saki_1_reply).can_be_destroyed_by?(users(:quentin))
    assert site_replies(:saki_1_reply).can_be_destroyed_by?(users(:saki))
    assert !site_replies(:ano_1_reply).can_be_destroyed_by?(users(:saki))
  end
  
  def test_replies_counter
    site_posts(:saki_1).site_replies(:refresh).size
    r = SiteReply.new(:content => "Test Reply")
    r.user = users(:saki)
    assert_difference "site_posts(:saki_1).site_replies.size" do
      site_posts(:saki_1).site_replies << r
      r.save!
    end
    
    assert_difference "SiteReply.count", -1 do
    assert_difference "site_posts(:saki_1).site_replies.size", -1 do
      site_posts(:saki_1).site_replies.delete(r)
    end
    end
  end
end

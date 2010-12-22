require File.dirname(__FILE__) + '/../test_helper'

class SiteReplyTest < ActiveSupport::TestCase
  def test_destroy
    assert !site_replies(:saki_1_reply).can_be_destroyed_by?(users(:quentin))
    assert site_replies(:saki_1_reply).can_be_destroyed_by?(users(:saki))
    assert site_replies(:saki_1_reply).can_be_destroyed_by?(users(:mike2))
    assert !site_replies(:ano_1_reply).can_be_destroyed_by?(users(:saki))
    assert site_replies(:ano_1_reply).can_be_destroyed_by?(users(:mike2))
  end
  
  def test_replies_counter
    site_posts(:saki_1).site_replies(:refresh).size
    r = SiteReply.new(:content => "Test Reply")
    r.user = users(:saki)
    assert_difference "site_posts(:saki_1).reload.site_replies.size" do
      site_posts(:saki_1).site_replies << r
      site_posts(:saki_1).save!
    end
    
    assert_difference "SiteReply.count", -1 do
    assert_difference "site_posts(:saki_1).reload.site_replies.size", -1 do
      site_posts(:saki_1).site_replies.delete(r)
    end
    end
  end

  def test_updated
    site_posts(:saki_1).updated_at = Time.now
    site_posts(:saki_1).save

    r = SiteReply.new(:content => "Test Reply")
    r.user = users(:saki)
    r.save

    r.site_post = site_posts(:saki_1)
    c_time = Time.now
    sleep(1)
    r.save 
    assert site_posts(:saki_1).reload.updated_at > c_time, "Reply save"

    r = SiteReply.new(:content => "Test Reply")
    r.user = users(:saki)
    c_time = Time.now
    sleep(1)
    site_posts(:saki_1).site_replies << r
    site_posts(:saki_1).save!
    assert site_posts(:saki_1).reload.updated_at > c_time, "Post << op save"
  end
end

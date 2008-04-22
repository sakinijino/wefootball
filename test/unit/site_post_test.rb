require File.dirname(__FILE__) + '/../test_helper'

class SitePostTest < ActiveSupport::TestCase
  def test_can_destroy
    assert site_posts(:saki_1).can_be_destroyed_by?(users(:saki))
    assert !site_posts(:saki_1).can_be_destroyed_by?(users(:mike1))
    assert !site_posts(:ano_1).can_be_destroyed_by?(users(:saki))
  end
  
  def test_destroy
    assert_difference 'SiteReply.count', -2 do
      site_posts(:saki_1).destroy
    end
  end
end

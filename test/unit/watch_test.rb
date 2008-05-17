require File.dirname(__FILE__) + '/../test_helper'

class WatchTest < ActiveSupport::TestCase
  
  def test_cascade_destroy_from_official_match_to_watch
    assert_equal 2, official_matches(:one).watches.size
    assert_difference('Watch.count', -2) do
      official_matches(:one).destroy
    end
  end

  def test_cascade_destroy_from_watch_to_watch_join 
    assert_equal 3, watches(:one).watch_joins.size
    assert_difference('WatchJoin.count', -3) do
      watches(:one).destroy
    end
  end
  
  def test_validation
    m = watches(:one)
    assert m.valid?
    m.start_time = 2.days.ago
    m.end_time = Time.now
    assert !m.valid?
    m.start_time = Time.now.since(3600)
    m.end_time = Time.now
    assert !m.valid?
    m.start_time = Time.now
    m.end_time = Time.now.since(1)
    assert !m.valid?
  end
  
  def test_before_validation #测试before_validation   
    m1 = Watch.new
    m1.location = "Beijing"
    m1.official_match = official_matches(:one)
    m1.save!
    assert_equal m1.official_match.start_time, m1.start_time
    assert_equal m1.official_match.end_time, m1.end_time
  end
  
  def test_time_check
    watches(:one).start_time = 3.hours.ago
    watches(:one).end_time = 4.hours.ago
    assert_equal false, !watches(:one).started?
    
    watches(:one).start_time = 2.hours.ago
    watches(:one).end_time = 2.hours.since
    assert_equal false, !watches(:one).started?

    watches(:one).start_time = 3.hours.since
    watches(:one).end_time = 4.hours.since
    assert_equal true, !watches(:one).started?
  end
  
  def test_has_member
    assert_equal true, watches(:one).has_member?(users(:saki)) 
    assert_equal false, watches(:one).has_member?(users(:mike1))    
  end
  
  def test_can_join
    assert_equal true, watches(:one).can_be_joined_by?(users(:mike1)) #可以加入
    assert_equal false, watches(:one).can_be_joined_by?(users(:saki)) #已加入，不能再加入
    assert_equal false, watches(:one).can_be_quited_by?(users(:mike1)) #未加入，不能退出
    assert_equal true, watches(:one).can_be_quited_by?(users(:saki)) #已加入，可以退出
  end
  
  def test_can_edit_or_destroy
    assert_equal false, watches(:one).can_be_edited_by?(users(:mike1))
    assert_equal true, watches(:one).can_be_edited_by?(users(:saki))
    assert_equal false, watches(:one).can_be_destroyed_by?(users(:mike1))
    assert_equal true, watches(:one).can_be_destroyed_by?(users(:saki))
  end
end

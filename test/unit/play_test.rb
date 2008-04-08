require File.dirname(__FILE__) + '/../test_helper'

class PlayTest < ActiveSupport::TestCase
  
  def test_should_create
    #测试无时间初值时的情况，此时时间采用默认值    
    p = Play.new({:football_ground_id=>football_grounds(:yiti).id})
    p.save!
    assert_not_nil p.id
    assert_equal 1.hour.since.strftime("%y-%m-%d-%H"), p.start_time.strftime("%y-%m-%d-%H")
    assert_equal 2.hours.since.strftime("%y-%m-%d-%H"), p.end_time.strftime("%y-%m-%d-%H")
    assert_equal football_grounds(:yiti).name, p.location
    
    #测试有时间初值时的情况
    p = Play.new(:football_ground_id=>football_grounds(:yiti).id,:start_time=>3.hours.since,:end_time=>4.hours.since)
    p.save!
    assert_not_nil p.id
    assert_equal 3.hour.since.strftime("%y-%m-%d-%H"), p.start_time.strftime("%y-%m-%d-%H")
    assert_equal 4.hours.since.strftime("%y-%m-%d-%H"), p.end_time.strftime("%y-%m-%d-%H")
    assert_equal football_grounds(:yiti).name, p.location  
  end
  
  def test_validate
    p = Play.new
    assert_equal false, p.valid?
    assert p.errors.on(:location)
    
    p = Play.new(:football_ground_id=>football_grounds(:yiti).id,:start_time=>30.minutes.ago,:end_time=>20.minutes.ago)
    assert_equal false, p.valid?
    assert p.errors.on(:start_time)
    assert p.errors.on(:end_time)

    p = Play.new(:location=>'s'*301)
    assert_equal false, p.valid?
    assert p.errors.on(:location)

    p = Play.new(:football_ground_id=>football_grounds(:yiti).id)
    assert_equal true, p.valid?    
  end
  
  def test_time_check
    plays(:play1).start_time = 3.hours.ago
    plays(:play1).end_time = 4.hours.ago
    assert_equal false, plays(:play1).is_before_play?
    
    plays(:play1).start_time = 2.hours.ago
    plays(:play1).end_time = 2.hours.since
    assert_equal false, plays(:play1).is_before_play?    

    plays(:play1).start_time = 3.hours.since
    plays(:play1).end_time = 4.hours.since
    assert_equal true, plays(:play1).is_before_play?    
  end

  def test_can_join
    PlayJoin.create!(:user_id=>users(:mike1).id,:play_id=>plays(:play1).id)    
    
    #如果play已经开始，则不能加入也不能退出    
    plays(:play1).start_time = 3.hours.ago
    assert_equal false, plays(:play1).can_be_joined_by?(users(:saki)) 
    assert_equal false, plays(:play1).can_be_joined_by?(users(:mike1))
    assert_equal false, plays(:play1).can_be_unjoined_by?(users(:saki)) 
    assert_equal false, plays(:play1).can_be_unjoined_by?(users(:mike1)) 
   
    #如果play尚未开始
    plays(:play1).start_time = 3.hours.since
    assert_equal true, plays(:play1).can_be_joined_by?(users(:saki)) #可以加入
    assert_equal false, plays(:play1).can_be_joined_by?(users(:mike1)) #已加入，不能再加入
    assert_equal false, plays(:play1).can_be_unjoined_by?(users(:saki)) #未加入，不能退出
    assert_equal true, plays(:play1).can_be_unjoined_by?(users(:mike1)) #已加入，可以退出
  end

end

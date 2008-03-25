require File.dirname(__FILE__) + '/../test_helper'

class MatchTest < ActiveSupport::TestCase

  def test_match_joins #测试到match_joins的关联正确
    m = matches(:one)
    assert_equal teams(:inter),m.host_team
    assert_equal teams(:milan),m.guest_team    
  end

  def test_protected_attr #测试attr_protected，以location为例
    m = matches(:one)
    default_location = m.location
    new_location = default_location + "_test"
    m.update_attributes!(:location=>new_location)
    assert_equal default_location,m.location
    m.location = new_location
    m.save!
    assert_equal new_location,m.location    
  end  

  def test_end_time #测试before_save中end_time的值设置正确
    m = matches(:one)
    m.start_time = "2008-03-20 14:00:00"
    m.half_match_length = 20
    m.rest_length = 20
    assert_equal 60,m.full_match_length
    m.save!
    assert_equal "2008-03-20 15:00:00" ,m.end_time.to_s(:db) 
  end
  
  def test_calculate_situation #测试calculate_situation
    situation_text = {1=>'不好说',2=>'狂胜', 3=>'完胜', 4=>'小胜', 5=>'势均力敌',6=>'惜败', 7=>'完败', 8=>'被虐'}    
    m = matches(:one) 
    assert_equal '狂胜',situation_text[Match.calculate_situation(5,0)]
    assert_equal '完胜',situation_text[Match.calculate_situation(4,0)]    
    assert_equal '完胜',situation_text[Match.calculate_situation(3,0)]    
    assert_equal '小胜',situation_text[Match.calculate_situation(2,0)]
    assert_equal '小胜',situation_text[Match.calculate_situation(1,0)]
    assert_equal '势均力敌',situation_text[Match.calculate_situation(0,0)]     
    assert_equal '惜败',situation_text[Match.calculate_situation(0,1)]
    assert_equal '惜败',situation_text[Match.calculate_situation(0,2)]
    assert_equal '完败',situation_text[Match.calculate_situation(0,3)]
    assert_equal '完败',situation_text[Match.calculate_situation(0,4)]
    assert_equal '被虐',situation_text[Match.calculate_situation(0,5)]   
  end
  
  def test_match_related_time_section #测试和比赛相关的三个时间段函数
    m = matches(:one)
    m.start_time = 9.days.since
    m.save
    assert_equal true,m.is_before_match?
    assert_equal false,m.is_after_match_and_before_match_close?
    assert_equal false,!m.is_before_match_close? #这里用!m.is_before_match_close?模拟m.is_after_match_close?       
    m.start_time = 1.days.ago
    m.save
    assert_equal false,m.is_before_match?
    assert_equal true,m.is_after_match_and_before_match_close?
    assert_equal false,!m.is_before_match_close?
    m.start_time = 9.days.ago
    m.save
    assert_equal false,m.is_before_match?
    assert_equal false,m.is_after_match_and_before_match_close?
    assert_equal true,!m.is_before_match_close? 
  end

  def test_cascade_destroy_between_match_and_match_join#测试match和matchJoin间的级联删除
    m = matches(:one)
    MatchJoin.create_joins(m)
    assert_equal false, m.match_joins.empty?
    match_join_num = m.match_joins.count
#    assert_equal true, m.match_joins.empty?
    assert_difference 'm.match_joins.count', 0-match_join_num do
      Match.destroy(m)
    end
  end

  def test_create_match_from_match_invitation
    mi = match_invitations(:inv1)
    m = Match.create_by_invitation(mi)
    assert_equal m.start_time, mi.new_start_time
    assert_equal m.location, mi.new_location
    assert_equal m.start_time, mi.new_start_time
    assert_equal m.match_type, mi.new_match_type
    assert_equal m.size, mi.new_size
    assert_equal m.has_judge, mi.new_has_judge
    assert_equal m.has_card, mi.new_has_card
    assert_equal m.has_offside, mi.new_has_offside
    assert_equal m.win_rule, mi.new_win_rule
    assert_equal m.description, mi.new_description
    assert_equal m.half_match_length, mi.new_half_match_length
    assert_equal m.rest_length, mi.new_rest_length
    assert_equal m.host_team_id, mi.host_team_id  
    assert_equal m.guest_team_id, mi.guest_team_id   
  end

end

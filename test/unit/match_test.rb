require File.dirname(__FILE__) + '/../test_helper'

class MatchTest < ActiveSupport::TestCase

  def test_match_joins #测试到match_joins的关联正确
    m = matches(:one)
    assert_equal teams(:inter),m.host_team
    assert_equal teams(:milan),m.guest_team

    MatchJoin.create_joins(m)
    assert_equal 4, m.match_joins.size
    
    assert_equal 2, m.match_joins.host_team.size  
    assert_equal users(:quentin), (m.match_joins.host_team.find{|i| i.user_id = users(:quentin).id}).user
    assert_nil m.match_joins.host_team.find{|i| i.user_id == users(:aaron).id}
    
    assert_equal 2, m.match_joins.guest_team.size
    assert_equal users(:aaron), (m.match_joins.guest_team.find{|i| i.user_id = users(:aaron).id}).user
    assert_nil m.match_joins.guest_team.find{|i| i.user_id == users(:quentin).id}
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
    assert_equal true,!m.started?
    assert_equal false,m.finished_and_before_close?
    assert_equal false,m.closed? #这里用m.closed?模拟m.is_after_match_close? 
    
    m.start_time = Time.now.ago(1800)
    m.half_match_length = 25
    m.rest_length = 10
    m.save!
    assert_equal false,!m.started?
    assert_equal false,m.finished_and_before_close?
    assert_equal true,!m.closed?
    
    m.start_time = 1.days.ago
    m.save
    assert_equal false,!m.started?
    assert_equal true,m.finished_and_before_close?
    assert_equal false,m.closed?
    
    m.start_time = 9.days.ago
    m.save
    assert_equal false,!m.started?
    assert_equal false,m.finished_and_before_close?
    assert_equal true,m.closed? 
  end

  def test_cascade_destroy_between_match_and_match_join#测试match和matchJoin间的级联删除
    m = matches(:one)
    MatchJoin.create_joins(m)
    assert_equal false, m.match_joins.empty?
    match_join_num = m.match_joins.length
    assert_difference 'MatchJoin.find_all_by_match_id(m.id).length', -match_join_num do
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

  def test_match_join_status
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    MatchJoin.destroy_all
    MatchJoin.create_joins(matches(:one))
    assert matches(:one).has_team_member?(users(:saki), teams(:inter).id) #待定
    assert matches(:one).has_team_member?(users(:quentin), teams(:inter).id) #待定
    assert !matches(:one).has_joined_team_member?(users(:saki), teams(:inter).id) #未加入
    assert !matches(:one).has_joined_team_member?(users(:quentin), teams(:inter).id) #未加入
    
    mj = MatchJoin.find_by_match_id_and_team_id_and_user_id(matches(:one),teams(:inter),users(:saki))
    mj.status = MatchJoin::JOIN
    mj.save!
    assert matches(:one).has_joined_team_member?(users(:saki), teams(:inter).id)
    
    assert matches(:one).has_team_member?(users(:saki), teams(:milan).id) #待定
    mj = MatchJoin.find_by_match_id_and_team_id_and_user_id(matches(:one),teams(:milan),users(:saki))
    mj.destroy
    assert !matches(:one).has_team_member?(users(:saki), teams(:milan).id)
    
    assert !matches(:one).has_joined_team_member?(users(:saki), teams(:juven).id) #错误的球队
    assert !matches(:one).has_joined_team_member?(users(:saki), teams(:juven).id) #错误的球队
  end
  
  def test_can_join
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    MatchJoin.destroy_all
    MatchJoin.create_joins(matches(:one))
    mj = MatchJoin.find_by_match_id_and_team_id_and_user_id(matches(:one),teams(:inter),users(:saki))
    mj.status = MatchJoin::JOIN
    mj.save!
    
    assert matches(:one).can_be_joined_by?(users(:quentin),teams(:inter)) #待定，可以加入
    assert !matches(:one).can_be_joined_by?(users(:saki),teams(:inter)) #已加入，不能再加入
    assert !matches(:one).can_be_joined_by?(users(:mike1),teams(:inter)) #不是本队，不能加入
    
    assert matches(:one).can_be_quited_by?(users(:quentin),teams(:inter)) #待定，不能退出
    assert matches(:one).can_be_quited_by?(users(:saki),teams(:inter)) #可以退出
    assert !matches(:one).can_be_quited_by?(users(:mike1),teams(:inter)) #不能退出
    
    matches(:one).start_time = 6.days.ago
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    
    assert !matches(:one).can_be_joined_by?(users(:quentin),teams(:inter)) #已经结束，不能加入
    assert !matches(:one).can_be_quited_by?(users(:saki),teams(:inter)) #已经结束，不能退出
 
    
    matches(:one).start_time = 8.days.ago
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    
    assert !matches(:one).can_be_joined_by?(users(:quentin),teams(:inter)) #关闭不能加入
    assert !matches(:one).can_be_quited_by?(users(:saki),teams(:inter)) #已经结束，不能退出
    
    assert !matches(:one).can_be_joined_by?(users(:saki), teams(:juven).id) #错误的球队
    assert !matches(:one).can_be_quited_by?(users(:saki), teams(:juven).id) #错误的球队
  end
  
  def test_can_edit_or_destroy
    user_teams(:aaron_milan).is_admin = true
    user_teams(:aaron_milan).save!
    
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    assert matches(:one).can_be_edited_formation_by?(users(:saki),teams(:inter))
    assert !matches(:one).can_be_edited_result_by?(users(:saki),teams(:inter))
    assert matches(:one).can_be_destroyed_by?(users(:saki))
    assert !matches(:one).can_be_edited_formation_by?(users(:aaron),teams(:inter))
    assert !matches(:one).can_be_edited_result_by?(users(:aaron),teams(:inter))
    assert matches(:one).can_be_destroyed_by?(users(:aaron))
    assert !matches(:one).can_be_edited_formation_by?(users(:mike1),teams(:inter))
    assert !matches(:one).can_be_edited_result_by?(users(:mike1),teams(:inter))
    assert !matches(:one).can_be_destroyed_by?(users(:mike1))
    
    matches(:one).start_time = Time.now.ago(1800)
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    assert matches(:one).can_be_edited_formation_by?(users(:saki),teams(:inter))
    assert !matches(:one).can_be_edited_result_by?(users(:saki),teams(:inter))
    assert !matches(:one).can_be_destroyed_by?(users(:saki))
    assert !matches(:one).can_be_edited_formation_by?(users(:aaron),teams(:inter))
    assert !matches(:one).can_be_edited_result_by?(users(:aaron),teams(:inter))
    assert !matches(:one).can_be_destroyed_by?(users(:aaron))
    assert !matches(:one).can_be_edited_formation_by?(users(:mike1),teams(:inter))
    assert !matches(:one).can_be_edited_result_by?(users(:mike1),teams(:inter))
    assert !matches(:one).can_be_destroyed_by?(users(:mike1))
    
    matches(:one).start_time = 6.days.ago
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    assert matches(:one).can_be_edited_formation_by?(users(:saki),teams(:inter))
    assert matches(:one).can_be_edited_result_by?(users(:saki),teams(:inter))
    assert !matches(:one).can_be_destroyed_by?(users(:saki))
    assert !matches(:one).can_be_edited_formation_by?(users(:aaron),teams(:inter))
    assert !matches(:one).can_be_edited_result_by?(users(:aaron),teams(:inter))
    assert !matches(:one).can_be_destroyed_by?(users(:aaron))
    assert !matches(:one).can_be_edited_formation_by?(users(:mike1),teams(:inter))
    assert !matches(:one).can_be_edited_result_by?(users(:mike1),teams(:inter))
    assert !matches(:one).can_be_destroyed_by?(users(:mike1))
    
    matches(:one).start_time = 8.days.ago
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    assert !matches(:one).can_be_edited_formation_by?(users(:saki),teams(:inter))
    assert !matches(:one).can_be_edited_result_by?(users(:saki),teams(:inter))
    assert !matches(:one).can_be_destroyed_by?(users(:saki))
    assert !matches(:one).can_be_edited_formation_by?(users(:aaron),teams(:inter))
    assert !matches(:one).can_be_edited_result_by?(users(:aaron),teams(:inter))
    assert !matches(:one).can_be_destroyed_by?(users(:aaron))
    assert !matches(:one).can_be_edited_formation_by?(users(:mike1),teams(:inter))
    assert !matches(:one).can_be_edited_result_by?(users(:mike1),teams(:inter))
    assert !matches(:one).can_be_destroyed_by?(users(:mike1))
    
    assert !matches(:one).can_be_edited_formation_by?(users(:saki), teams(:juven).id) #错误的球队
    assert !matches(:one).can_be_edited_result_by?(users(:saki), teams(:juven).id) #错误的球队
  end
  
  def test_public_posts
    m = Match.find(1)
    assert_equal 2, m.posts.team(2).length
    assert_equal 1, m.posts.team(2, :limit=>1).length
    assert_equal 1, m.posts.team_public(2).length
    
    assert_equal 1, m.posts.team(2, :page=>1, :per_page=>1).length
    assert_equal 1, m.posts.team_public(2, :page=>1, :per_page=>1).current_page
  end
  
  def test_posts_dependency_nullify
    t = Match.find(1)
    l  = t.posts.team(t.host_team).size
    assert_not_equal 0, l
    assert_no_difference "t.host_team.posts.reload.length" do
    assert_difference "t.host_team.posts.find(:all, :conditions=>['match_id is not null']).length", -l do
      t.destroy
    end
    end
  end

  def test_destroy
    m = MatchJoin.new
    m.user = users(:saki)
    m.team_id = 1
    m.match_id = 1
    m.save!
    
    assert_difference 'MatchJoin.count', -1 do
      Match.find(1).destroy
    end
  end
  
  def test_judge_conflict
    
    #场景1:主队填了单边比分,客队填了双边比分,此时只比较双方的交集
    m = Match.new
    m.location = 'test'
    m.host_team_goal_by_host = 1
    m.host_team_goal_by_guest = 1
    m.guest_team_goal_by_guest = 2
    m.save!
    assert_equal false, m.has_conflict
    
    m = Match.new
    m.location = 'test'
    m.guest_team_goal_by_host = 2
    m.host_team_goal_by_guest = 1
    m.guest_team_goal_by_guest = 2
    m.save!    
    assert_equal false, m.has_conflict
    
    m = Match.new
    m.location = 'test'
    m.host_team_goal_by_host = 1
    m.host_team_goal_by_guest = 2
    m.guest_team_goal_by_guest = 1
    m.save!    
    assert_equal true, m.has_conflict 
    
    m = Match.new
    m.location = 'test'
    m.guest_team_goal_by_host = 1
    m.host_team_goal_by_guest = 2
    m.guest_team_goal_by_guest = 2     
    m.save!    
    assert_equal true, m.has_conflict  
    
    #场景2:主队填写了单边比分,客队填写了赛况,则一定不会产生冲突
    situation_index = 1
    while situation_index <= 8
      m = Match.new
      m.location = 'test'
      m.host_team_goal_by_host = 1
      m.situation_by_guest = situation_index
      m.save!
      assert_equal false, m.has_conflict
      situation_index = situation_index + 1
    end
    
    #场景3:主队和客队都填写了双边比分,则可能产生冲突
    m = Match.new
    m.location = 'test'
    m.host_team_goal_by_host = 1
    m.guest_team_goal_by_host = 2    
    m.host_team_goal_by_guest = 1
    m.guest_team_goal_by_guest = 2
    m.save!
    assert_equal false, m.has_conflict
    
    m = Match.new
    m.location = 'test'
    m.host_team_goal_by_host = 1
    m.guest_team_goal_by_host = 2    
    m.host_team_goal_by_guest = 2
    m.guest_team_goal_by_guest = 2
    m.save!    
    assert_equal true, m.has_conflict
    
    m = Match.new
    m.location = 'test'
    m.host_team_goal_by_host = 1
    m.guest_team_goal_by_host = 2    
    m.host_team_goal_by_guest = 3
    m.guest_team_goal_by_guest = 4     
    m.save!    
    assert_equal true, m.has_conflict     
    
    #场景3:主队和客队都填写了赛况,则可能产生冲突
    m = Match.new
    m.location = 'test'
    m.situation_by_host = 1
    m.situation_by_guest = 1       
    m.save!    
    assert_equal false, m.has_conflict
    
    m = Match.new
    m.location = 'test'
    m.situation_by_host = 1
    m.situation_by_guest = 2       
    m.save!    
    assert_equal true, m.has_conflict    
    
    #场景5:主队填写了双边比分,客队填写了赛况,则可能产生冲突
    m = Match.new
    m.location = 'test'
    m.host_team_goal_by_host = 1
    m.guest_team_goal_by_host = 1
    m.situation_by_guest = 5       
    m.save!    
    assert_equal false, m.has_conflict
    
    m = Match.new
    m.location = 'test'
    m.host_team_goal_by_host = 1
    m.guest_team_goal_by_host = 1
    m.situation_by_guest = 4
    m.save!    
    assert_equal true, m.has_conflict     
  end
end

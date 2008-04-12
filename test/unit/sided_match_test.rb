require File.dirname(__FILE__) + '/../test_helper'

class SidedMatchTest < ActiveSupport::TestCase
  
  def test_host_team_and_guest_team #测试到host_team和guest_team的关联正确
    m = sided_matches(:one)
    m.host_team_id = teams(:inter).id
    assert_equal m.host_team,teams(:inter)
  end
  
  def test_before_validation #测试before_validation   
    m1 = SidedMatch.new
    m1.guest_team_name = "AC"
    m1.location = "Beijing"
    m1.start_time = 1.day.since
    m1.half_match_length = 45
    m1.rest_length = 15
    m1.save!
    assert_equal "", m1.description
    assert_equal 5, m1.size
    assert_equal 1, m1.match_type
    assert_equal 1, m1.win_rule
    
    m2 = sided_matches(:one)
    m2.update_attributes!({:description =>'s'*4000})
    m2.save!
    assert_equal m2.description.length,SidedMatch::MAX_DESCRIPTION_LENGTH
  end  

  def test_match_joins #测试到match_joins的关联正确
    m = sided_matches(:one)
    assert_equal teams(:inter),m.host_team

    SidedMatchJoin.create_joins(m)
    assert_equal 2, m.sided_match_joins.size
    assert_equal users(:quentin), (m.sided_match_joins.to_a.find{|i| i.user_id = users(:quentin).id}).user
    
    assert_equal teams(:inter).users.size, m.users.undetermined.size
    assert_equal 0, m.users.joined.size
  end

  def test_end_time #测试before_save中end_time的值设置正确
    m = sided_matches(:one)
    m.start_time = "2008-03-20 14:00:00"
    m.half_match_length = 20
    m.rest_length = 20
    assert_equal 60,m.full_match_length
    m.save!
    assert_equal "2008-03-20 15:00:00" ,m.end_time.to_s(:db) 
  end
  
  def test_calculate_situation #测试calculate_situation
    situation_text = {1=>'不好说',2=>'狂胜', 3=>'完胜', 4=>'小胜', 5=>'势均力敌',6=>'惜败', 7=>'完败', 8=>'被虐'}    
    m = sided_matches(:one) 
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
    m = sided_matches(:one)
    m.start_time = 9.days.since
    m.save
    assert_equal true,m.is_before_match?
    assert_equal false,m.is_after_match?
    
    m.start_time = Time.now.ago(1800)
    m.half_match_length = 25
    m.rest_length = 10
    m.save!
    assert_equal false,m.is_before_match?
    assert_equal false,m.is_after_match?
    
    m.start_time = 1.days.ago
    m.save
    assert_equal false,m.is_before_match?
    assert_equal true,m.is_after_match?
  end

  def test_cascade_destroy_between_match_and_match_join#测试match和matchJoin间的级联删除
    m = sided_matches(:one)
    SidedMatchJoin.create_joins(m)
    assert_equal false, m.sided_match_joins.empty?
    match_join_num = m.sided_match_joins.length
    assert_difference 'SidedMatchJoin.find_all_by_match_id(m.id).length', -match_join_num do
      SidedMatch.destroy(m)
    end
  end

  def test_match_join_status
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    SidedMatchJoin.destroy_all
    SidedMatchJoin.create_joins(sided_matches(:one))
    assert sided_matches(:one).has_member?(users(:saki)) #待定
    assert sided_matches(:one).has_member?(users(:quentin)) #待定
    assert !sided_matches(:one).has_joined_member?(users(:saki)) #未加入
    assert !sided_matches(:one).has_joined_member?(users(:quentin)) #未加入
    
    mj = SidedMatchJoin.find_by_match_id_and_user_id(sided_matches(:one),users(:saki))
    mj.status = SidedMatchJoin::JOIN
    mj.save!
    assert sided_matches(:one).has_joined_member?(users(:saki))
    
    assert sided_matches(:one).has_member?(users(:saki)) #待定
    mj = SidedMatchJoin.find_by_match_id_and_user_id(sided_matches(:one),users(:saki))
    mj.destroy
    assert !sided_matches(:one).has_member?(users(:saki))
  end
  
  def test_can_join
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    SidedMatchJoin.destroy_all
    SidedMatchJoin.create_joins(sided_matches(:one))
    mj = SidedMatchJoin.find_by_match_id_and_user_id(sided_matches(:one),users(:saki))
    mj.status = SidedMatchJoin
    mj.save!
    
    assert sided_matches(:one).can_be_joined_by?(users(:quentin)) #待定，可以加入
    assert !sided_matches(:one).can_be_joined_by?(users(:saki)) #已加入，不能再加入
    assert !sided_matches(:one).can_be_joined_by?(users(:mike1)) #不是本队，不能加入
    
    assert sided_matches(:one).can_be_quited_by?(users(:quentin)) #待定，不能退出
    assert sided_matches(:one).can_be_quited_by?(users(:saki)) #可以退出
    assert !sided_matches(:one).can_be_quited_by?(users(:mike1)) #不能退出
    
    sided_matches(:one).start_time = 6.days.ago
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    
    assert !sided_matches(:one).can_be_joined_by?(users(:quentin)) #已经结束，不能加入
    assert !sided_matches(:one).can_be_quited_by?(users(:saki)) #已经结束，不能退出
  end
  
  def test_can_edit_or_destroy
    user_teams(:aaron_milan).is_admin = true
    user_teams(:aaron_milan).save!
    
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    assert sided_matches(:one).can_be_edited_by?(users(:saki))
    assert sided_matches(:one).can_be_edited_formation_by?(users(:saki))
    assert !sided_matches(:one).can_be_edited_result_by?(users(:saki))
    assert sided_matches(:one).can_be_destroyed_by?(users(:saki))
    assert !sided_matches(:one).can_be_edited_by?(users(:mike1))
    assert !sided_matches(:one).can_be_edited_formation_by?(users(:mike1))
    assert !sided_matches(:one).can_be_edited_result_by?(users(:mike1))
    assert !sided_matches(:one).can_be_destroyed_by?(users(:mike1))
    
    sided_matches(:one).start_time = Time.now.ago(1800)
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    assert !sided_matches(:one).can_be_edited_by?(users(:saki))
    assert sided_matches(:one).can_be_edited_formation_by?(users(:saki))
    assert !sided_matches(:one).can_be_edited_result_by?(users(:saki))
    assert sided_matches(:one).can_be_destroyed_by?(users(:saki))
    assert !sided_matches(:one).can_be_edited_by?(users(:mike1))
    assert !sided_matches(:one).can_be_edited_formation_by?(users(:mike1))
    assert !sided_matches(:one).can_be_edited_result_by?(users(:mike1))
    assert !sided_matches(:one).can_be_destroyed_by?(users(:mike1))
    
    sided_matches(:one).start_time = 6.days.ago
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    assert !sided_matches(:one).can_be_edited_by?(users(:saki))
    assert sided_matches(:one).can_be_edited_formation_by?(users(:saki))
    assert sided_matches(:one).can_be_edited_result_by?(users(:saki))
    assert sided_matches(:one).can_be_destroyed_by?(users(:saki))
    assert !sided_matches(:one).can_be_edited_by?(users(:mike1))
    assert !sided_matches(:one).can_be_edited_formation_by?(users(:mike1))
    assert !sided_matches(:one).can_be_edited_result_by?(users(:mike1))
    assert !sided_matches(:one).can_be_destroyed_by?(users(:mike1))
  end
  
#  def test_public_posts
#    m = Match.find(1)
#    assert_equal 2, m.posts.team(2).length
#    assert_equal 1, m.posts.team(2, :limit=>1).length
#    assert_equal 1, m.posts.team_public(2).length
#  end
#  
#  def test_posts_dependency_nullify
#    t = Match.find(1)
#    l  = t.posts.team(t.host_team).size
#    assert_not_equal 0, l
#    assert_no_difference "t.host_team.posts.length" do
#    assert_difference "t.host_team.posts.find(:all, :conditions=>['match_id is not null']).length", -l do
#      t.destroy
#    end
#    end
#  end
end

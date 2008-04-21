require File.dirname(__FILE__) + '/../test_helper'

class SidedMatchesControllerTest < ActionController::TestCase
  def test_should_create_sided_match
    login_as :saki
    assert_difference('SidedMatchJoin.count', teams(:inter).users.size) do
    assert_difference('SidedMatch.count') do
      post :create, :sided_match => { :host_team_id => teams(:inter).id, :guest_team_name=>'AC', :location=>"School" }
      assert_redirected_to sided_match_path(assigns(:sided_match))
    end
    end
    
    assert_equal teams(:inter).users.size, assigns(:sided_match).users.undetermined.size
    assert_equal 0, assigns(:sided_match).users.joined.size
  end
  
  def test_should_be_admin_before_create_sided_match
    login_as :mike1
    assert_no_difference('SidedMatch.count') do
      post :create, :sided_match => { :host_team_id => teams(:inter).id, :guest_team_name=>'AC' }
      assert_redirected_to '/'
    end
  end
  
  def test_should_update_sided_match
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 45
    sided_matches(:one).rest_length = 15
    sided_matches(:one).save!
    login_as :saki
    t = Time.now.tomorrow.at_midnight.since(3600)
    put :update, :id => sided_matches(:one).id, :sided_match => { :start_time=> t} 
    assert_redirected_to sided_match_path(assigns(:sided_match))
    assert_equal t.to_s, SidedMatch.find(sided_matches(:one).id).start_time.to_s
  end  
  
  def test_should_not_update_sided_match_after_it_started
    sided_matches(:one).start_time = Time.now.ago(1800)
    sided_matches(:one).half_match_length = 45
    sided_matches(:one).rest_length = 15
    sided_matches(:one).save!
    login_as :mike1
    t = Time.now
    put :update, :id => sided_matches(:one).id, :sided_match => { :start_time=> t}
    assert_redirected_to '/'
  end
  
  def test_should_be_admin_before_update_sided_match
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 45
    sided_matches(:one).rest_length = 15
    sided_matches(:one).save!
    login_as :mike1
    t = Time.now
    put :update, :id => sided_matches(:one).id, :sided_match => { :start_time=> t}
    assert_redirected_to '/'
  end

  def test_should_destroy_sided_match
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 45
    sided_matches(:one).rest_length = 15
    sided_matches(:one).save!
    login_as :saki
    assert_difference('SidedMatch.count', -1) do
      delete :destroy, :id => sided_matches(:one).id
      assert_redirected_to team_view_path(assigns(:sided_match).host_team)
    end
  end
  
#  def test_should_not_destroy_sided_match_after_it_finished_3_days
#    sided_matches(:one).start_time = 5.days.ago
#    sided_matches(:one).half_match_length = 45
#    sided_matches(:one).rest_length = 15
#    sided_matches(:one).save_without_validation!
#    login_as :mike1
#    assert_no_difference('SidedMatch.count') do
#      delete :destroy, :id => sided_matches(:one).id
#      assert_redirected_to '/'
#    end
#  end
  
  def test_should_be_admin_before_destroy_sided_match
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 45
    sided_matches(:one).rest_length = 15
    sided_matches(:one).save!
    login_as :mike1
    assert_no_difference('SidedMatch.count') do
      delete :destroy, :id => sided_matches(:one).id
      assert_redirected_to '/'
    end
  end
  
  def test_should_update_result
    login_as :saki #准备数据,这里为了清晰,不使用夹具数据
    u1 = users(:saki)
    u2 = users(:mike1)
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    ut1 = UserTeam.new
    ut1.user_id = u1.id
    ut1.team_id = t1.id
    ut1.is_admin = true
    ut1.is_player = true
    ut1.save!
    ut2 = UserTeam.new
    ut2.user_id = u2.id
    ut2.team_id = t1.id
    ut2.is_player = true
    ut2.save!
    
    match1 = SidedMatch.new   
    match1.host_team_id = t1.id
    match1.guest_team_name = 'AC'
    match1.start_time = 1.days.ago
    match1.location = '一体'
    match1.save!
    SidedMatchJoin.create_joins(match1)

    assert_equal nil, match1.guest_team_goal
    assert_equal nil, match1.host_team_goal
    assert_equal nil, match1.situation

    mj1 = SidedMatchJoin.find_by_user_id_and_match_id(u1.id, match1.id)
    mj2 = SidedMatchJoin.find_by_user_id_and_match_id(u2.id, match1.id)     
    put :update_result, :id => match1.id, :sided_match => {:host_team_goal => 2,
                                              :guest_team_goal => 2,
                                              :situation => 1
                                              },
                                    :mj => {mj1.id=>{:goal=>1,:cards=>2},
                                            mj2.id=>{:goal=>1,:cards=>3}
                                           }
    new_match1 = SidedMatch.find(match1)
    assert_equal 2, new_match1.guest_team_goal
    assert_equal 2, new_match1.host_team_goal
    assert_not_equal 0, new_match1.situation
    assert_equal Match.calculate_situation(new_match1.host_team_goal, new_match1.guest_team_goal), new_match1.situation
    new_mj1 = SidedMatchJoin.find_by_user_id_and_match_id(u1.id, match1.id)
    new_mj2 = SidedMatchJoin.find_by_user_id_and_match_id(u2.id, match1.id)     
    assert_equal 1, new_mj1.goal
    assert_equal 2, new_mj1.cards    
    assert_equal 1, new_mj2.goal
    assert_equal 3, new_mj2.cards    
    assert_redirected_to sided_match_path(match1)

    put :update_result, :id => match1.id, :team_id=>t1.id, :sided_match => {
        :host_team_goal => "",
        :guest_team_goal => "",
        :situation => 5},
                                    :mj => {}#ceshi
    new_match1 = SidedMatch.find(match1)
    assert_equal 5, new_match1.situation
    assert_redirected_to sided_match_path(match1)
  end
  
  def test_check_goals_in_update
    login_as :saki #准备数据,这里为了清晰,不使用夹具数据
    u1 = users(:saki)
    u2 = users(:mike1)
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    ut1 = UserTeam.new
    ut1.user_id = u1.id
    ut1.team_id = t1.id
    ut1.is_admin = true
    ut1.is_player = true
    ut1.save!
    ut2 = UserTeam.new
    ut2.user_id = u2.id
    ut2.team_id = t1.id
    ut2.is_player = true
    ut2.save!      
    
    match1 = SidedMatch.new   
    match1.host_team_id = t1.id
    match1.guest_team_name = '大巴萨'
    match1.start_time = 1.days.ago
    match1.location = '一体'
    match1.save!
    SidedMatchJoin.create_joins(match1)

    assert_equal nil, match1.host_team_goal

    mj1 = SidedMatchJoin.find_by_user_id_and_match_id(u1.id,match1.id)
    mj2 = SidedMatchJoin.find_by_user_id_and_match_id(u2.id,match1.id)
    assert_equal 0, mj1.goal
    assert_equal 0, mj2.goal    
    put :update_result, :id => match1.id, :sided_match => {
                                              :host_team_goal => 2,
                                              :guest_team_goal => 2,
                                              },
                                    :mj => {mj1.id=>{:goal=>1},
                                            mj2.id=>{:goal=>1}
                                           }
    new_match1 = SidedMatch.find(match1)                              
    assert_equal 2, new_match1.guest_team_goal
    assert_equal 2, new_match1.guest_team_goal
    new_mj1 = SidedMatchJoin.find_by_user_id_and_match_id(u1.id,match1.id)
    new_mj2 = SidedMatchJoin.find_by_user_id_and_match_id(u2.id,match1.id)     
    assert_equal 1, new_mj1.goal   
    assert_equal 1, new_mj2.goal
    assert_redirected_to sided_match_path(new_match1)

    put :update_result, :id => match1.id, :sided_match => {
                                              :host_team_goal => 2,
                                              :guest_team_goal => 2,
                                              },
                                    :mj => {mj1.id=>{:goal=>1},
                                            mj2.id=>{}
                                           }
    new_match1 = SidedMatch.find(match1)                              
    assert_equal 2, new_match1.guest_team_goal
    assert_equal 2, new_match1.guest_team_goal
    new_mj1 = SidedMatchJoin.find_by_user_id_and_match_id(u1.id,match1.id)
    new_mj2 = SidedMatchJoin.find_by_user_id_and_match_id(u2.id,match1.id)     
    assert_equal 1, new_mj1.goal   
    assert_equal 0, new_mj2.goal
    assert_redirected_to sided_match_path(new_match1)   

    put :update_result, :id => match1.id, :sided_match => {
                                              :host_team_goal => 2,
                                              :guest_team_goal => 2,
                                              },
                                    :mj => {mj1.id=>{:goal=>2},
                                            mj2.id=>{:goal=>1}
                                           }
    new_match1 = SidedMatch.find(match1)                              
    assert_equal 2, new_match1.guest_team_goal
    assert_equal 2, new_match1.guest_team_goal
    new_mj1 = SidedMatchJoin.find_by_user_id_and_match_id(u1.id,match1.id)
    new_mj2 = SidedMatchJoin.find_by_user_id_and_match_id(u2.id,match1.id)     
    assert_equal 1, new_mj1.goal   
    assert_equal 0, new_mj2.goal
    assert_equal "队员入球总数不能超过本队入球数", assigns(:sided_match).errors['base']
    assert_template 'edit_result'       
  end  
  
  def test_should_not_update
    login_as :saki
    u1 = users(:saki)
    u2 = users(:mike1)
    
    t1 = Team.create!(:name=>"test1",:shortname=>"t1") 
    ut1 = UserTeam.new 
    ut1.user_id = u1.id
    ut1.team_id = t1.id 
    ut1.is_admin = true
    ut1.is_player = true    
    ut1.save!
    ut2 = UserTeam.new
    ut2.user_id = u2.id
    ut2.team_id = t1.id
    ut2.is_player = true
    ut2.save!     
    
    match1 = SidedMatch.new   
    match1.host_team_id = t1.id
    match1.guest_team_name = 'AC'
    match1.start_time = 2.days.since
    match1.location = '一体'
    match1.save!
    SidedMatchJoin.create_joins(match1)   
    put :update_result, :id => match1.id, :team_id=>t1.id, :sided_match => {}, :mj => {}
    assert_redirected_to '/'

    match1.start_time = 1.days.ago
    match1.save!
    ut1.is_admin = false
    ut1.save!
    put :update_result, :id => match1.id, :team_id=>t1.id, :sided_match => {}, :mj => {}#处理不是管理员的情况  
    assert_redirected_to '/'
    
    SidedMatchJoin.create_joins(matches(:one))
    tmp = SidedMatchJoin.find_by_user_id_and_match_id(u1.id, matches(:one))
    assert_not_nil tmp
    put :update, :id => match1.id, :team_id=>t1.id, :match => {:host_team_goal => 2,
                                              :guest_team_goal => 2,
                                              :situation => 0
                                              },
                                    :mj => {tmp.id=>{:goal=>1,:cards=>2}}#处理match_join不是本场比赛的情况
    assert_redirected_to '/'
    
    ut1.is_admin = true #复位为管理员
    ut1.save!

    mj1 = SidedMatchJoin.find_by_user_id_and_match_id(u1.id, match1.id)
    mj2 = SidedMatchJoin.find_by_user_id_and_match_id(u2.id, match1.id)
    put :update_result, :id => match1.id, :sided_match => {:host_team_goal => 2,
                                              :guest_team_goal => 2,
                                              :situation => 0
                                              },
                                    :mj => {mj1.id=>{:goal=>5,:cards=>2},
                                            mj2.id=>{:goal=>3,:cards=>3}
                                           }
    assert_template 'edit_result'
  end  
end

require File.dirname(__FILE__) + '/../test_helper'

class MatchesControllerTest < ActionController::TestCase
  
  def test_unlogin
    get :edit
    assert_redirected_to new_session_path    
    post :create
    assert_redirected_to new_session_path
    put :update
    assert_redirected_to new_session_path
    delete :destroy
    assert_redirected_to new_session_path     
  end

  def test_should_create_match
    login_as :saki
    u1 = users(:saki)
    u2 = users(:mike1)
    
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")   
    ut1 = UserTeam.new #current_user(saki)是t1队的成员，但并不是管理员
    ut1.user_id = u1.id
    ut1.team_id = t1.id 
    ut1.is_admin = true
    ut1.save!
    ut2 = UserTeam.new
    ut2.user_id = u2.id
    ut2.team_id = t2.id
    ut2.save!    
    
    inv1 = MatchInvitation.new   
    inv1.host_team_id = t1.id
    inv1.guest_team_id = t2.id
    inv1.new_half_match_length = 45
    inv1.new_rest_length = 15
    inv1.new_start_time = 2.days.since
    inv1.new_location = '一体'
    inv1.edit_by_host_team = true
    inv1.save!
   
    assert_difference('Match.count') do
      post :create, :id => inv1.id, :match_invitation=>{}
    end
    assert_redirected_to match_path(assigns(:match))
  end
  
  def test_should_not_create_match #测试create中两种不应该创建的情况
    login_as :saki
    u1 = users(:saki)
    u2 = users(:mike1)
    
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")   
    ut1 = UserTeam.new #current_user(saki)是t1队的成员，但并不是管理员
    ut1.user_id = u1.id
    ut1.team_id = t1.id 
    ut1.is_admin = false
    ut1.save!
    ut2 = UserTeam.new
    ut2.user_id = u2.id
    ut2.team_id = t2.id
    ut2.save!    
    
    inv1 = MatchInvitation.new   
    inv1.host_team_id = t1.id
    inv1.guest_team_id = t2.id
    inv1.new_start_time = 2.days.since
    inv1.new_half_match_length = 45
    inv1.new_rest_length = 15
    inv1.new_location = '一体'
    inv1.edit_by_host_team = true
    inv1.save!
    assert_no_difference('Match.count') do
      post :create, :id => inv1.id
    end
    assert_redirected_to '/'
    
    ut1.is_admin = true
    ut1.save!   
    assert_difference('Match.count') do
      post :create, :id => inv1.id
    end
    assert_redirected_to match_path(assigns(:match))
  end
  
  def test_should_not_create_match_with_an_outdated_mactch_invitation
    login_as :saki
    u = users(:saki)
 
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    inv = MatchInvitation.new
    inv.host_team_id = t1.id
    inv.guest_team_id = t2.id
    inv.new_location = "Beijing"
    inv.new_start_time = 1.day.ago
    inv.new_half_match_length = 45
    inv.new_rest_length = 15
    inv.edit_by_host_team = true #如果当前是主队在编辑
    inv.save_without_validation!
    ut = UserTeam.new
    ut.user_id = u.id
    ut.team_id = t1.id
    ut.is_admin = true
    ut.save!
    
    assert_no_difference('Match.count') do
      post :create, :id => inv.id
    end
    assert_redirected_to '/'
  end 


  def test_should_edit
    login_as :saki
    u1 = users(:saki)
    
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")   
    ut1 = UserTeam.new 
    ut1.user_id = u1.id
    ut1.team_id = t1.id 
    ut1.is_admin = true
    ut1.is_player = true    
    ut1.save!  
    
    match1 = Match.new   
    match1.host_team_id = t1.id
    match1.guest_team_id = t2.id
    match1.start_time = 1.days.ago
    match1.location = '一体'
    match1.save!
    MatchJoin.create_joins(match1)
    
    get :edit, :id => match1.id, :team_id=>t1.id   
    assert_equal true, assigns(:editing_by_host_team)
    assert_equal [u1], assigns(:player_mjs).map{|item| item.user}.sort_by{|item| item.id}
    assert_response :success    
  end
  

  def test_should_not_edit
    login_as :saki
    u1 = users(:saki)
    
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")   
    ut1 = UserTeam.new 
    ut1.user_id = u1.id
    ut1.team_id = t1.id 
    ut1.is_admin = true
    ut1.is_player = true    
    ut1.save!  
    
    match1 = Match.new   
    match1.host_team_id = t1.id
    match1.guest_team_id = t2.id
    match1.start_time = 1.days.since #比赛尚未开始
    match1.location = '一体'
    match1.save!
    MatchJoin.create_joins(match1)   
    get :edit, :id => match1.id, :team_id=>t1.id   
    assert_redirected_to '/'

    match1.start_time = 1.days.ago #复位为正常时间
    match1.save!
    get :edit, :id => match1.id, :team_id=>t1.id   
    assert_response :success     
    
    get :edit, :id => match1.id, :team_id=>t2.id #处理user_id和team_id可能不匹配的情况  
    assert_redirected_to '/'

    ut1.is_admin = false
    ut1.save!
    get :edit, :id => match1.id, :team_id=>t2.id #处理user_id和team_id可能不匹配的情况  
    assert_redirected_to '/'      
  end  

  
  def test_should_update_by_host_team
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
    
    match1 = Match.new   
    match1.host_team_id = t1.id
    match1.guest_team_id = t2.id
    match1.start_time = 1.days.ago
    match1.location = '一体'
    match1.save!
    MatchJoin.create_joins(match1)

    assert_equal nil, match1.guest_team_goal_by_host
    assert_equal nil, match1.host_team_goal_by_host
    assert_equal nil, match1.guest_team_goal_by_guest
    assert_equal nil, match1.host_team_goal_by_guest
    assert_equal nil, match1.situation_by_host

    mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    put :update, :id => match1.id, :team_id=>t1.id, :match => {:host_team_goal_by_host => 2,
                                              :guest_team_goal_by_host => 2,
                                              :host_team_goal_by_guest => 2,
                                              :guest_team_goal_by_guest => 2,
                                              :situation_by_host => 1
                                              },
                                    :mj => {mj1.id=>{:goal=>1,:cards=>2},
                                            mj2.id=>{:goal=>1,:cards=>3}
                                           }
    new_match1 = Match.find(match1)
    assert_equal 2, new_match1.guest_team_goal_by_host
    assert_equal 2, new_match1.host_team_goal_by_host
    assert_equal nil, new_match1.guest_team_goal_by_guest
    assert_equal nil, new_match1.host_team_goal_by_guest
    assert_not_equal 0, new_match1.situation_by_host
    assert_equal Match.calculate_situation(new_match1.host_team_goal_by_host,new_match1.guest_team_goal_by_host), new_match1.situation_by_host
    new_mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    new_mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    assert_equal 1, new_mj1.goal
    assert_equal 2, new_mj1.cards    
    assert_equal 1, new_mj2.goal
    assert_equal 3, new_mj2.cards    
    assert_redirected_to match_path(new_match1)

    put :update, :id => match1.id, :team_id=>t1.id, :match => {:host_team_goal_by_host => "",
                                              :guest_team_goal_by_host => "",
                                              :situation_by_host => 5},
                                    :mj => {}#ceshi
    new_match1 = Match.find(match1)                              
    assert_equal 5, new_match1.situation_by_host
    assert_redirected_to match_path(new_match1)
  end
  
  def test_should_update_by_guest_team
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
    
    match1 = Match.new   
    match1.host_team_id = t2.id
    match1.guest_team_id = t1.id
    match1.start_time = 1.days.ago
    match1.location = '一体'
    match1.save!
    MatchJoin.create_joins(match1)

    assert_equal nil, match1.guest_team_goal_by_guest
    assert_equal nil, match1.host_team_goal_by_guest
    assert_equal nil, match1.guest_team_goal_by_host
    assert_equal nil, match1.host_team_goal_by_host
    assert_equal nil, match1.situation_by_host

    mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    put :update, :id => match1.id, :team_id=>t1.id, :match => {:host_team_goal_by_guest => 2,
                                              :guest_team_goal_by_guest => 2,
                                              :host_team_goal_by_host => 2,
                                              :guest_team_goal_by_host => 2,
                                              :situation_by_guest => 1
                                              },
                                    :mj => {mj1.id=>{:goal=>1,:cards=>2},
                                            mj2.id=>{:goal=>1,:cards=>3}
                                           }
    new_match1 = Match.find(match1)                              
    assert_equal 2, new_match1.guest_team_goal_by_guest
    assert_equal 2, new_match1.host_team_goal_by_guest
    assert_equal nil, new_match1.guest_team_goal_by_host
    assert_equal nil, new_match1.host_team_goal_by_host
    assert_not_equal 0, new_match1.situation_by_guest
    assert_equal Match.calculate_situation(new_match1.host_team_goal_by_guest,new_match1.guest_team_goal_by_guest), new_match1.situation_by_guest
    new_mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    new_mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    assert_equal 1, new_mj1.goal
    assert_equal 2, new_mj1.cards    
    assert_equal 1, new_mj2.goal
    assert_equal 3, new_mj2.cards
    assert_redirected_to match_path(new_match1)

    put :update, :id => match1.id, :team_id=>t1.id, :match => {:host_team_goal_by_guest => "",
                                              :guest_team_goal_by_guest => "",
                                              :situation_by_guest => 5},
                                    :mj => {}#ceshi
    new_match1 = Match.find(match1)                              
    assert_equal 5, new_match1.situation_by_guest
    assert_redirected_to match_path(new_match1)
  end

  def test_check_host_team_goals_in_update
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
    
    match1 = Match.new   
    match1.host_team_id = t1.id
    match1.guest_team_id = t2.id
    match1.start_time = 1.days.ago
    match1.location = '一体'
    match1.save!
    MatchJoin.create_joins(match1)

    assert_equal nil, match1.guest_team_goal_by_host
    assert_equal nil, match1.host_team_goal_by_host

    mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)
    assert_equal 0, mj1.goal
    assert_equal 0, mj2.goal    
    put :update, :id => match1.id, :team_id=>t1.id, :match => {
                                              :host_team_goal_by_host => 2,
                                              :guest_team_goal_by_host => 2,
                                              },
                                    :mj => {mj1.id=>{:goal=>1},
                                            mj2.id=>{:goal=>1}
                                           }
    new_match1 = Match.find(match1)                              
    assert_equal 2, new_match1.guest_team_goal_by_host
    assert_equal 2, new_match1.guest_team_goal_by_host
    new_mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    new_mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    assert_equal 1, new_mj1.goal   
    assert_equal 1, new_mj2.goal
    assert_redirected_to match_path(new_match1)

    put :update, :id => match1.id, :team_id=>t1.id, :match => {
                                              :host_team_goal_by_host => 2,
                                              :guest_team_goal_by_host => 2,
                                              },
                                    :mj => {mj1.id=>{:goal=>1},
                                            mj2.id=>{}
                                           }
    new_match1 = Match.find(match1)                              
    assert_equal 2, new_match1.guest_team_goal_by_host
    assert_equal 2, new_match1.guest_team_goal_by_host
    new_mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    new_mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    assert_equal 1, new_mj1.goal   
    assert_equal 0, new_mj2.goal
    assert_redirected_to match_path(new_match1)   

    put :update, :id => match1.id, :team_id=>t1.id, :match => {
                                              :host_team_goal_by_host => 2,
                                              :guest_team_goal_by_host => 2,
                                              },
                                    :mj => {mj1.id=>{:goal=>2},
                                            mj2.id=>{:goal=>1}
                                           }
    new_match1 = Match.find(match1)                              
    assert_equal 2, new_match1.guest_team_goal_by_host
    assert_equal 2, new_match1.guest_team_goal_by_host
    new_mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    new_mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    assert_equal 1, new_mj1.goal   
    assert_equal 0, new_mj2.goal
    assert_equal "队员入球总数不能超过本队入球数", assigns(:match).errors['base']
    assert_template 'edit'       
  end
  
  def test_check_guest_team_goals_in_update
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
    
    match1 = Match.new   
    match1.host_team_id = t2.id
    match1.guest_team_id = t1.id
    match1.start_time = 1.days.ago
    match1.location = '一体'
    match1.save!
    MatchJoin.create_joins(match1)

    assert_equal nil, match1.guest_team_goal_by_guest
    assert_equal nil, match1.host_team_goal_by_guest

    mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)
    assert_equal 0, mj1.goal
    assert_equal 0, mj2.goal    
    put :update, :id => match1.id, :team_id=>t1.id, :match => {
                                              :host_team_goal_by_guest => 2,
                                              :guest_team_goal_by_guest => 2,
                                              },
                                    :mj => {mj1.id=>{:goal=>1},
                                            mj2.id=>{:goal=>1}
                                           }
    new_match1 = Match.find(match1)                              
    assert_equal 2, new_match1.guest_team_goal_by_guest
    assert_equal 2, new_match1.guest_team_goal_by_guest
    new_mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    new_mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    assert_equal 1, new_mj1.goal   
    assert_equal 1, new_mj2.goal
    assert_redirected_to match_path(new_match1)

    put :update, :id => match1.id, :team_id=>t1.id, :match => {
                                              :host_team_goal_by_guest => 2,
                                              :guest_team_goal_by_guest => 2,
                                              },
                                    :mj => {mj1.id=>{:goal=>1},
                                            mj2.id=>{}
                                           }
    new_match1 = Match.find(match1)                              
    assert_equal 2, new_match1.guest_team_goal_by_guest
    assert_equal 2, new_match1.guest_team_goal_by_guest
    new_mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    new_mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    assert_equal 1, new_mj1.goal   
    assert_equal 0, new_mj2.goal
    assert_redirected_to match_path(new_match1)   

    put :update, :id => match1.id, :team_id=>t1.id, :match => {
                                              :host_team_goal_by_guest => 2,
                                              :guest_team_goal_by_guest => 2,
                                              },
                                    :mj => {mj1.id=>{:goal=>2},
                                            mj2.id=>{:goal=>1}
                                           }
    new_match1 = Match.find(match1)                              
    assert_equal 2, new_match1.guest_team_goal_by_guest
    assert_equal 2, new_match1.guest_team_goal_by_guest
    new_mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    new_mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    assert_equal 1, new_mj1.goal   
    assert_equal 0, new_mj2.goal
    assert_equal "队员入球总数不能超过本队入球数", assigns(:match).errors['base']
    assert_template 'edit'       
  end
  
  def test_should_not_update
    login_as :saki
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
    ut2 = UserTeam.new
    ut2.user_id = u2.id
    ut2.team_id = t2.id
    ut2.is_player = true
    ut2.save!
    
    match1 = Match.new   
    match1.host_team_id = t1.id
    match1.guest_team_id = t2.id
    match1.start_time = 1.days.since #比赛尚未开始
    match1.location = '一体'
    match1.save!
    MatchJoin.create_joins(match1)   
    put :update, :id => match1.id, :team_id=>t1.id, :match => {}, :mj => {}
    assert_redirected_to '/'

    match1.start_time = 1.days.ago #复位为正常时间
    match1.save!    
    put :update, :id => match1.id, :team_id=>t2.id, :match => {}, :mj => {}#处理user_id和team_id可能不匹配的情况     
    assert_redirected_to '/'
    
    tmp = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t2.id,match1.id)
    assert_not_nil tmp
    put :update, :id => match1.id, :team_id=>t1.id, :match => {:host_team_goal_by_guest => 2,
                                              :guest_team_goal_by_guest => 2,
                                              :situation_by_guest => 0
                                              },
                                    :mj => {tmp.id=>{:goal=>1,:cards=>2}}#处理match_join不是本队的情况
    assert_redirected_to '/'

    ut1.is_admin = false
    ut1.save!
    put :update, :id => match1.id, :team_id=>t1.id, :match => {}, :mj => {}#处理不是管理员的情况  
    assert_redirected_to '/'
    
    ut1.is_admin = true #复位为管理员
    ut1.save!

    mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    put :update, :id => match1.id, :team_id=>t1.id, 
            :match => {:host_team_goal_by_guest => 2,
            :guest_team_goal_by_guest => 2,
            :host_team_goal_by_host => 2,
            :guest_team_goal_by_host => 2,
            :situation_by_guest => 0
          },
            :mj => {mj1.id=>{:goal=>5,:cards=>2},
            mj2.id=>{:goal=>3,:cards=>3}
          }
    assert_template 'edit'
  end  

  def test_should_destroy_match
    login_as :saki
    u1 = users(:saki)
    
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")   
    ut1 = UserTeam.new 
    ut1.user_id = u1.id
    ut1.team_id = t1.id 
    ut1.is_admin = true
    ut1.save!  
    
    match1 = Match.new   
    match1.host_team_id = t1.id
    match1.guest_team_id = t2.id
    match1.start_time = Time.now.tomorrow
    match1.half_match_length = 20
    match1.rest_length = 20
    match1.location = '一体'
    match1.save!
    MatchJoin.create_joins(match1)
     
    assert_difference('Match.count',-1) do
      delete :destroy, :id => match1.id
    end
    assert_redirected_to team_view_path(t1)
  end
  
  def test_should_not_destroy_match
    login_as :saki
    u1 = users(:saki)
    
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")   
    ut1 = UserTeam.new 
    ut1.user_id = u1.id
    ut1.team_id = t1.id 
    ut1.is_admin = true
    ut1.save!  
    
    match1 = Match.new   
    match1.host_team_id = t1.id
    match1.guest_team_id = t2.id
    match1.start_time = 1.days.ago #比赛结束后无法删除
    match1.half_match_length = 20
    match1.rest_length = 20
    match1.location = '一体'
    match1.save!
    MatchJoin.create_joins(match1)
     
    assert_no_difference('Match.count') do
      delete :destroy, :id => match1.id
    end
    assert_redirected_to '/'    

    match1.start_time = Time.now.tomorrow
    match1.half_match_length = 20
    match1.rest_length = 20
    match1.save!

    ut1.is_admin = false
    ut1.save!
    assert_no_difference('Match.count') do
      delete :destroy, :id => match1.id
    end
    assert_redirected_to '/'    
  end  
end

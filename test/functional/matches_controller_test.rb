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

  def test_should_get_index_by_user_id
    u1 = users(:saki)
    get :index, :user_id=>u1.id
    assert_equal 0,assigns(:matches).size
    assert_response :success
    
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    t3 = Team.create!(:name=>"test3",:shortname=>"t3")    
    ut = UserTeam.new
    ut.user_id = u1.id
    ut.team_id = t1.id
    ut.save!
    
    match1 = Match.new   
    match1.host_team_id = t1.id
    match1.guest_team_id = t2.id
    match1.start_time = 2.days.since
    match1.location = "一体"
    match1.save!
    MatchJoin.create_joins(match1)   
    get :index, :user_id=>u1.id
    assert_equal 1,assigns(:matches).size
    assert_response :success
    
    match2 = Match.new  #无关比赛不应该改变u1的比赛计数
    match2.host_team_id = t2.id
    match2.guest_team_id = t3.id
    match2.start_time = 2.days.since
    match2.location = "一体"
    match2.save!
    MatchJoin.create_joins(match2)
    get :index, :user_id=>u1.id
    assert_equal 1,assigns(:matches).size
    assert_response :success

    match1.start_time = 2.days.ago #测试recent方法是否起作用
    match1.save!  
    get :index, :user_id=>u1.id
    assert_equal 0,assigns(:matches).size
    assert_response :success    
  end
  
  def test_should_get_index_by_team_id
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    t3 = Team.create!(:name=>"test3",:shortname=>"t3") 
    
    get :index, :team_id => t1.id
    assert_equal 0,assigns(:matches).size
    assert_response :success
    
    match1 = Match.new   
    match1.host_team_id = t1.id
    match1.guest_team_id = t2.id
    match1.start_time = 2.days.since
    match1.location = "一体"
    match1.save!  
    get :index, :team_id => t1.id
    assert_equal 1,assigns(:matches).size
    assert_response :success
    
    match2 = Match.new  #无关比赛不应该改变u1的比赛计数
    match2.host_team_id = t2.id
    match2.guest_team_id = t3.id
    match2.start_time = 2.days.since
    match2.location = "一体"
    match2.save!
    get :index, :team_id => t1.id
    assert_equal 1,assigns(:matches).size
    assert_response :success

    match1.start_time = 2.days.ago #测试recent方法是否起作用
    match1.save!  
    get :index, :team_id => t1.id
    assert_equal 0,assigns(:matches).size
    assert_response :success    
  end 

  def test_show
    u1 = users(:saki)
    u2 = users(:mike1)
    u3 = users(:mike2)
    
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")   
    ut1 = UserTeam.new
    ut1.user_id = u1.id
    ut1.team_id = t1.id   
    ut1.save!
    ut2 = UserTeam.new
    ut2.user_id = u2.id
    ut2.team_id = t2.id
    ut2.save!
    ut3 = UserTeam.new
    ut3.user_id = u3.id
    ut3.team_id = t2.id  
    ut3.save!    
    
    match1 = Match.new   
    match1.host_team_id = t1.id
    match1.guest_team_id = t2.id
    match1.start_time = 2.days.since
    match1.location = "一体"
    match1.save!
    MatchJoin.create_joins(match1)
    
    mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id).update_attributes(:position=>1)
    mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t2.id,match1.id).update_attributes(:position=>1)
    
    get :show, :id=>match1.id
    assert_equal [u1],assigns(:host_team_player_mjs).map{|item| item.user}
    assert_equal [u1],assigns(:host_team_user_mjs).map{|item| item.user}
    assert_equal [u2],assigns(:guest_team_player_mjs).map{|item| item.user}
    assert_equal [u2,u3],assigns(:guest_team_user_mjs).map{|item| item.user}    
    assert_response :success
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
    inv1.new_location = '一体'
    inv1.edit_by_host_team = true
    inv1.save!
    assert_no_difference('Match.count') do
      post :create, :id => inv1.id, :match_invitation=>{}
    end
    assert_redirected_to '/'
    
    ut1.is_admin = true
    ut1.save!   
    assert_difference('Match.count') do
      post :create, :id => inv1.id, :match_invitation=>{}
    end
    assert_redirected_to match_path(assigns(:match))

    Match.destroy_all
    inv2 = MatchInvitation.new   
    inv2.host_team_id = t1.id
    inv2.guest_team_id = t2.id
    inv2.new_start_time = 3.days.since
    inv2.new_location = '一体'
    inv2.edit_by_host_team = true
    inv2.save!    
    assert_no_difference('Match.count') do
      post :create, :id => inv2.id, :match_invitation=>{:new_location => '五四'}
    end
    assert_template 'edit'   
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
    assert_equal nil, match1.guest_team_goal_by_guest
    assert_equal nil, match1.situation_by_host

    mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    put :update, :id => match1.id, :team_id=>t1.id, :match => {:host_team_goal_by_host => 2,
                                              :guest_team_goal_by_host => 2,
                                              :host_team_goal_by_guest => 2,
                                              :guest_team_goal_by_guest => 2,
                                              :situation_by_host => 0
                                              },
                                    :mj => {mj1.id=>{:goal=>1,:cards=>2,:comment=>'nb'},
                                            mj2.id=>{:goal=>1,:cards=>3,:comment=>'nb2'}
                                           }
    new_match1 = Match.find(match1)                              
    assert_equal 2, new_match1.guest_team_goal_by_host
    assert_equal 2, new_match1.host_team_goal_by_host
    assert_equal nil, new_match1.guest_team_goal_by_guest
    assert_equal nil, new_match1.guest_team_goal_by_guest
    assert_not_equal 0, new_match1.situation_by_host
    assert_equal Match.calculate_situation(new_match1.host_team_goal_by_host,new_match1.guest_team_goal_by_host), new_match1.situation_by_host
    new_mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    new_mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    assert_equal 1, new_mj1.goal
    assert_equal 2, new_mj1.cards    
    assert_equal 'nb', new_mj1.comment
    assert_equal 1, new_mj2.goal
    assert_equal 3, new_mj2.cards    
    assert_equal 'nb2', new_mj2.comment    
    assert_redirected_to team_view_path(t1)                                   

    put :update, :id => match1.id, :team_id=>t1.id, :match => {:situation_by_host => 0},
                                    :mj => {}#ceshi
    new_match1 = Match.find(match1)                              
    assert_equal 0, new_match1.situation_by_host
    assert_redirected_to team_view_path(t1)           
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
    assert_equal nil, match1.guest_team_goal_by_host
    assert_equal nil, match1.situation_by_host

    mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    put :update, :id => match1.id, :team_id=>t1.id, :match => {:host_team_goal_by_guest => 2,
                                              :guest_team_goal_by_guest => 2,
                                              :host_team_goal_by_host => 2,
                                              :guest_team_goal_by_host => 2,
                                              :situation_by_guest => 0
                                              },
                                    :mj => {mj1.id=>{:goal=>1,:cards=>2,:comment=>'nb'},
                                            mj2.id=>{:goal=>1,:cards=>3,:comment=>'nb2'}
                                           }
    new_match1 = Match.find(match1)                              
    assert_equal 2, new_match1.guest_team_goal_by_guest
    assert_equal 2, new_match1.host_team_goal_by_guest
    assert_equal nil, new_match1.guest_team_goal_by_host
    assert_equal nil, new_match1.guest_team_goal_by_host
    assert_not_equal 0, new_match1.situation_by_guest
    assert_equal Match.calculate_situation(new_match1.host_team_goal_by_guest,new_match1.guest_team_goal_by_guest), new_match1.situation_by_guest
    new_mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    new_mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    assert_equal 1, new_mj1.goal
    assert_equal 2, new_mj1.cards    
    assert_equal 'nb', new_mj1.comment
    assert_equal 1, new_mj2.goal
    assert_equal 3, new_mj2.cards    
    assert_equal 'nb2', new_mj2.comment    
    assert_redirected_to team_view_path(t1)                                   

    put :update, :id => match1.id, :team_id=>t1.id, :match => {:situation_by_guest => 0},
                                    :mj => {}#ceshi
    new_match1 = Match.find(match1)                              
    assert_equal 0, new_match1.situation_by_guest
    assert_redirected_to team_view_path(t1)           
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

    ut1.is_admin = false
    ut1.save!
    put :update, :id => match1.id, :team_id=>t1.id, :match => {}, :mj => {}#处理不是管理员的情况  
    assert_redirected_to '/'
    
    ut1.is_admin = true #复位为管理员
    ut1.save!

    mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u1.id,t1.id,match1.id)
    mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(u2.id,t1.id,match1.id)     
    put :update, :id => match1.id, :team_id=>t1.id, :match => {:host_team_goal_by_guest => 2,
                                              :guest_team_goal_by_guest => 2,
                                              :host_team_goal_by_host => 2,
                                              :guest_team_goal_by_host => 2,
                                              :situation_by_guest => 0
                                              },
                                    :mj => {mj1.id=>{:goal=>5,:cards=>2,:comment=>'nb'},
                                            mj2.id=>{:goal=>3,:cards=>3,:comment=>'nb2'}
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
    match1.start_time = 5.days.ago #比赛结束后无法删除
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
    match1.start_time = 10.days.ago #比赛结束后无法删除
    match1.location = '一体'
    match1.save!
    MatchJoin.create_joins(match1)
     
    assert_no_difference('Match.count') do
      delete :destroy, :id => match1.id
    end
    assert_redirected_to '/'    

    match1.start_time = 5.days.ago #复位
    match1.save!

    ut1.is_admin = false
    ut1.save!
    assert_no_difference('Match.count') do
      delete :destroy, :id => match1.id
    end
    assert_redirected_to '/'    
  end  
end

require File.dirname(__FILE__) + '/../test_helper'

class TeamViewsControllerTest < ActionController::TestCase
  def test_show_unlogin
    teams(:inter).team_join_requests_count = 1
    teams(:inter).save!
    get :show, :id => teams(:inter).id  # 未登录
    assert_select "#send_team_join_request_div", 0
    assert_select "img[src*=inviteIntoTeam]", 0
    assert_select "img[src*=quitFromTeam]", 0
    assert_equal 0, assigns(:team_join_request_count)
  end
  
  def test_show_with_invitation
    login_as :mike1    
    get :show, :id => teams(:inter).id # 有邀请
    assert_select "#send_team_join_request_div", 0
    assert_select "img[src*=inviteIntoTeam]", 0
    assert_select "img[src*=quitFromTeam]", 0
  end
  
  def test_show_with_request
    login_as :mike2
    get :show, :id => teams(:inter).id # 已申请
    assert_select "#send_team_join_request_div", 0
    assert_select "img[src*=inviteIntoTeam]", 0
    assert_select "img[src*=quitFromTeam]", 0
  end
  
  def test_show_not_member
    teams(:inter).team_join_requests_count = 1
    teams(:inter).save!
    login_as :mike3
    get :show, :id => teams(:inter).id # 非队员
    assert_select "#send_team_join_request_div"
    assert_select "img[src*=inviteIntoTeam]"
    assert_select "img[src*=quitFromTeam]", 0
    assert_equal 0, assigns(:team_join_request_count)
  end
  
  def test_show_member
    TeamJoinRequest.destroy_all
    teams(:inter).team_join_requests_count = 0
    teams(:inter).save!
    tjr = TeamJoinRequest.new
    tjr.team = teams(:inter)
    tjr.user = users(:mike1)
    tjr.save!
    login_as :aaron
    get :show, :id => teams(:milan).id # 队员
    assert_select "#send_team_join_request_div", 0
    assert_select "img[src*=inviteIntoTeam]", 0
    assert_select "img[src*=quitFromTeam]"
    assert_equal 0, assigns(:team_join_request_count)
  end
  
  def test_show_admin
    TeamJoinRequest.destroy_all
    teams(:inter).team_join_requests_count = 0
    teams(:inter).save!
    tjr = TeamJoinRequest.new
    tjr.team = teams(:inter)
    tjr.user = users(:mike1)
    tjr.save!
    login_as :saki
    get :show, :id => teams(:inter).id # 管理员
    assert_select "#send_team_join_request_div", 0
    assert_select "img[src*=inviteIntoTeam]", 1
    assert_select "img[src*=quitFromTeam]"
    assert_equal 1, assigns(:team_join_request_count)
  end
  
  def test_show_only_one_admin
    TeamJoinRequest.destroy_all
    login_as :saki
    get :show, :id => teams(:milan).id # 唯一管理员
    assert_select "#send_team_join_request_div", 0
    assert_select "img[src*=inviteIntoTeam]", 1
    assert_select "img[src*=quitFromTeam]", 0
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class TeamJoinsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  include AuthenticatedTestHelper
  
  def test_admin
    login_as :saki
    get :admin_management, :team_id => 2
    assert_equal 1, assigns(:admin_uts).length
    assert_equal 1, assigns(:other_uts).length
  end
  
  def test_admin_noauth
    login_as :mike3
    get :admin_management, :team_id => 1
    assert_redirected_to '/'
  end
  
  def test_player
    ut = UserTeam.new
    ut.user_id = users(:mike1)
    ut.team_id = 2
    ut.save!
    user_teams(:saki_milan).update_attributes!(:is_player => true)
    users(:aaron).update_attributes!(:is_playable => true, :premier_position => 1, :fitfoot=>'R')
    login_as :saki
    get :player_management, :team_id => 2
    assert_equal 1, assigns(:player_uts).length
    assert_equal 1, assigns(:other_uts).length
  end
  
  def test_player_noauth
    login_as :mike3
    get :player_management, :team_id => 1
    assert_redirected_to '/'
  end
  
  def test_accept_invitation
    login_as :mike1
    assert_difference('TeamJoinRequest.count', -1) do
    assert_difference('UserTeam.count') do
      assert_difference('User.find(users(:mike1).id).teams.length') do
        post :create, :id=>5, :back_uri => '/public'
        assert_redirected_to '/public'#team_view_path(assigns(:tjs).team_id)
      end
    end
    end
  end
  
  def test_accept_request
    login_as :saki
    assert_difference('TeamJoinRequest.count', -1) do
    assert_difference('UserTeam.count') do
      assert_difference('User.find(users(:mike2).id).teams.length') do
        post :create, :id=>6
        assert_redirected_to team_view_path(assigns(:tjs).team_id)
      end
    end
    end
  end
  
  def test_invitaion_unauth
    login_as :saki
    assert_no_difference('UserTeam.count') do
      assert_no_difference('User.find(users(:mike1).id).teams.length') do
        post :create, :id=>5
        assert_redirected_to '/'
      end
    end
  end
  
  def test_request_unauth
    login_as :mike2
    assert_no_difference('UserTeam.count') do
      assert_no_difference('User.find(users(:mike2).id).teams.length') do
        post :create, :id=>6
        assert_redirected_to '/'
      end
    end
  end
  
  def test_update
    login_as :saki
    assert_difference('Team.find(teams(:milan)).users.admin.length') do
      put :update, :id=>UserTeam.find_by_user_id_and_team_id(users(:aaron).id, teams(:milan).id).id, 
        :ut=>{:is_admin => true}, :back_uri => '/public'
      assert_redirected_to '/public'
    end
  end
  
  def test_redirect_degree_self_as_common_user #将自己变为普通用户之后，跳回队首页
    login_as :saki
    assert_difference('Team.find(teams(:inter)).users.admin.length', -1) do
      put :update, :id=>UserTeam.find_by_user_id_and_team_id(users(:saki).id, 
        teams(:inter).id).id, :ut=>{:is_admin => false}, :back_uri => '/public'
      assert_redirected_to team_view_path(assigns(:team))
    end
  end
  
  def test_degree_as_common_user_fail
    login_as :saki
    assert_no_difference('Team.find(teams(:milan)).users.admin.length') do
      put :update, :id=>UserTeam.find_by_user_id_and_team_id(users(:saki).id, 
        teams(:milan).id).id, :ut=>{:is_admin => false}, :back_uri => '/public'
      assert_redirected_to '/public'
    end
  end
  
  def test_update_is_player
    login_as :saki
    put :update, :id=>UserTeam.find_by_user_id_and_team_id(users(:aaron).id, teams(:milan).id).id, 
      :ut=>{:is_player => true}, :back_uri => '/public'
    assert !UserTeam.find_by_user_id_and_team_id(users(:aaron).id, teams(:milan).id).is_player
    assert_redirected_to '/public'
  end
  
  def test_update_formation
    UserTeam.destroy_all
    ut = UserTeam.new
    ut.user = users(:saki)
    ut.team = teams(:inter)
    ut.is_admin = true
    ut.is_player = true
    ut.save!
    login_as :saki
    put :update_formation, :team_id=>teams(:inter).id, :formation => {'3'=>ut.id}
    assert_redirected_to formation_management_team_joins_path(:team_id => teams(:inter))
    assert_equal 3, ut.reload.position
    
    users(:mike1).update_attributes!(:is_player => true, :fitfoot => 'R', :premier_position=>1)
    ut2 = UserTeam.new
    ut2.user = users(:mike1)
    ut2.team = teams(:inter)
    ut2.is_player = true
    ut2.save!
    put :update_formation, :team_id=>teams(:inter).id, :formation => {'3'=>ut2.id}
    assert_redirected_to formation_management_team_joins_path(:team_id => teams(:inter))
    assert_nil ut.reload.position
    assert_equal 3, ut2.reload.position
    
    put :update_formation, :team_id=>teams(:inter).id, :formation => {'2'=>ut2.id, '20'=>ut.id}
    assert_redirected_to formation_management_team_joins_path(:team_id => teams(:inter))
    assert_equal 20, ut.reload.position
    assert_equal 2, ut2.reload.position
    
    put :update_formation, :team_id=>teams(:inter).id, :formation => {'2'=>ut2.id, '27'=>ut.id}
    assert_redirected_to formation_management_team_joins_path(:team_id => teams(:inter))
    assert_nil ut.reload.position
    assert_equal 2, ut2.reload.position
  end
  
  def test_update_unauth
    login_as :mike2
    assert_no_difference('Team.find(teams(:milan)).users.admin.length') do
      put :update, :id=>UserTeam.find_by_user_id_and_team_id(users(:aaron).id, teams(:milan).id).id, :ut=>{:is_admin => true}
      assert_redirected_to '/'
    end
  end
  
  def test_update_formation_unauth
    login_as :mike2
    put :update_formation, :team_id=>teams(:inter).id, :formation => {'3'=>user_teams(:saki_inter).id}
    assert_redirected_to '/'
  end
  
  def test_update_formation_with_a_user_team_from_other_team
    login_as :saki
    user_teams(:saki_inter).position = 11
    user_teams(:saki_inter).save!
    put :update_formation, :team_id=>teams(:inter).id, :formation => {'13'=>user_teams(:saki_inter).id, '16'=>user_teams(:saki_milan).id}
    assert_equal 11, user_teams(:saki_inter).position
    assert_redirected_to '/'
  end
  
  def test_update_formation_with_too_many_positions
    uts = {}
    (0..11).each do |i|
      uts[i.to_s] = UserTeam.new
      uts[i.to_s].user = create_user("mike#{i}@position.com")
      uts[i.to_s].team = teams(:inter)
      uts[i.to_s].is_player = true
      uts[i.to_s].save!
    end
    login_as :saki
    user_teams(:saki_inter).position = 11
    user_teams(:saki_inter).save!
    put :update_formation, :team_id=>teams(:inter).id, 
      :formation => uts
    assert_equal 11, user_teams(:saki_inter).position
    assert_redirected_to '/'
  end
  
  def test_destroy_unauth
    login_as :mike2
    delete :destroy, :id => UserTeam.find_by_user_id_and_team_id(users(:aaron).id, teams(:milan).id).id
    assert_redirected_to team_view_path(teams(:milan))
  end
  
  def test_destroy
    login_as :saki
    assert_difference "UserTeam.count", -1 do
      delete :destroy, :id => UserTeam.find_by_user_id_and_team_id(users(:aaron).id, teams(:milan).id).id, :back_uri => '/public'
      assert_redirected_to '/public'
    end
  end
  
protected
  def create_user(login)
    u = User.new :password => 'quire', :password_confirmation => 'quire'
    u.login = login
    u.is_playable = true
    u.fitfoot = 'R'
    u.premier_position = 0
    u.save!
    u
  end
end

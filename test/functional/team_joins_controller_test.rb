require File.dirname(__FILE__) + '/../test_helper'

class TeamJoinsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  include AuthenticatedTestHelper
  
  def test_accept_invitation
    login_as :mike1
    assert_difference('TeamJoinRequest.count', -1) do
    assert_difference('UserTeam.count') do
      assert_difference('User.find(users(:mike1).id).teams.length') do
        post :create, :id=>5
        assert_redirected_to team_view_path(assigns(:tjs).team_id)
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
      put :update, :id=>UserTeam.find_by_user_id_and_team_id(users(:aaron).id, teams(:milan).id).id, :ut=>{:is_admin => true}
      assert_redirected_to team_team_joins_path(assigns(:team))
    end
  end
  
  def test_update_is_player
    login_as :saki
    assert_difference('Team.find(teams(:milan)).formation.size') do
      put :update, :id=>UserTeam.find_by_user_id_and_team_id(users(:saki).id, teams(:milan).id).id, :ut=>{:is_player => true, :position=>0}
      assert UserTeam.find_by_user_id_and_team_id(users(:saki).id, teams(:milan).id).is_player
      assert_redirected_to team_team_joins_path(assigns(:team))
    end
    assert_no_difference('Team.find(teams(:milan)).formation.size') do
      put :update, :id=>UserTeam.find_by_user_id_and_team_id(users(:aaron).id, teams(:milan).id).id, :ut=>{:is_player => true}
      assert !UserTeam.find_by_user_id_and_team_id(users(:aaron).id, teams(:milan).id).is_player
      assert_redirected_to team_team_joins_path(assigns(:team))
    end
  end
  
  def test_update_unauth
    login_as :mike2
    assert_no_difference('Team.find(teams(:milan)).users.admin.length') do
      put :update, :id=>UserTeam.find_by_user_id_and_team_id(users(:aaron).id, teams(:milan).id).id, :ut=>{:is_admin => true}
      assert_redirected_to '/'
    end
  end
  
  def test_destroy_unauth
    login_as :mike2
    delete :destroy, :id => UserTeam.find_by_user_id_and_team_id(users(:aaron).id, teams(:milan).id).id
    assert_redirected_to '/'
  end
  
  def test_destroy
    login_as :saki
    c = UserTeam.count
    delete :destroy, :id => UserTeam.find_by_user_id_and_team_id(users(:aaron).id, teams(:milan).id).id
    assert_redirected_to user_view_path(assigns(:tj).user_id)
    assert_equal c-1, UserTeam.count
  end
end

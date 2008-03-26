require File.dirname(__FILE__) + '/../test_helper'

class TeamJoinInvitationsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  def test_index_unlogin
    get :index, :team_id=>teams(:inter).id
    assert_redirected_to new_session_path
  end
  
  def test_index_user_invitations
    login_as :saki
    get :index
    assert_template 'index_team'
    assert_equal 1, assigns(:requests).length
  end
  
  def test_index_team_invitations
    login_as :saki
    get :index, :team_id=>teams(:inter).id
    assert_template 'index_user'
    assert_equal 3, assigns(:requests).length
  end
  
  def test_create_invitation
    TeamJoinRequest.destroy_all
    assert_difference('TeamJoinRequest.count') do
      assert_difference('TeamJoinRequest.count :conditions=>["user_id = ? and is_invitation = true", users(:mike2).id]') do
        login_as :saki
        post :create, :team_join_request => { 
          :user_id => users(:mike2).id, 
          :team_id => teams(:inter).id,
          :message => 'hello'
        }
        assert_equal 'hello', assigns(:tjs).message
      end
    end
  end
  
  def test_create_invitation_should_be_admin
    assert_no_difference('TeamJoinRequest.count') do
      login_as :mike1
      post :create, :team_join_request => { 
        :user_id => users(:mike3).id, 
        :team_id => teams(:inter).id,
        :message => 'hello'
      }
      assert_redirected_to '/'
    end
  end
  
  def test_create_invitation_should_not_in_team
    TeamJoinRequest.destroy_all
    assert_equal 0, TeamJoinRequest.count
    assert_no_difference('TeamJoinRequest.count') do
      login_as :saki
      post :create, :team_join_request => { 
        :user_id => users(:saki).id, 
        :team_id => teams(:inter).id,
        :message => 'hello'
      }
      assert_redirected_to '/'
    end
  end
  
  def test_create_invitation_twice_with_long_message
    assert_no_difference('TeamJoinRequest.count') do
      login_as :saki
      post :create, :team_join_request => { 
        :user_id => users(:mike1).id, 
        :team_id => teams(:inter).id,
        :message => 'hello'*1000
      }
      assert_equal 150, assigns(:tjs).message.length
    end
  end
  
  def test_create_multi_invitation_with_teams
    TeamJoinRequest.destroy_all
    assert_difference('TeamJoinRequest.count', 2) do
      assert_difference('TeamJoinRequest.count :conditions=>["user_id = ? and is_invitation = true", users(:mike2).id]', 2) do
        login_as :saki
        post :create, :teams_id => [teams(:inter).id, teams(:milan).id],
          :team_join_request => { 
            :user_id => users(:mike2).id, 
            :message => 'hello'
          }
        assert_equal 'hello', assigns(:tjs).message
      end
    end
  end
  
  def test_create_multi_invitation_with_users
    TeamJoinRequest.destroy_all
    assert_difference('TeamJoinRequest.count', 2) do
      assert_difference('TeamJoinRequest.count :conditions=>["user_id = ? and is_invitation = true", users(:mike2).id]') do
      assert_difference('TeamJoinRequest.count :conditions=>["user_id = ? and is_invitation = true", users(:mike1).id]') do
        login_as :saki
        post :create, :users_id => [users(:mike1).id, users(:mike2).id],
          :team_join_request => { 
            :team_id => teams(:inter).id,
            :message => 'hello'
          }
        assert_equal 'hello', assigns(:tjs).message
      end
      end
    end
  end
  
  def test_create_multi_invitation_with_an_error
    TeamJoinRequest.destroy_all
    assert_no_difference('TeamJoinRequest.count :conditions=>["user_id = ? and is_invitation = true", users(:saki).id]') do
      login_as :saki
      post :create, :users_id => [users(:mike1).id, users(:saki).id, users(:mike2).id],
        :team_join_request => { 
        :team_id => teams(:inter).id,
        :message => 'hello'
      }
      assert users(:saki).id, assigns(:user).id
      assert_redirected_to '/'
    end
    TeamJoinRequest.destroy_all
    assert_no_difference('TeamJoinRequest.count :conditions=>["team_id = ? and is_invitation = true", teams(:juven).id]') do
      login_as :saki
      post :create, :teams_id => [teams(:inter).id, teams(:juven).id, teams(:milan).id],
        :team_join_request => { 
        :user_id => users(:mike2).id, 
        :message => 'hello'
      }
      assert teams(:juven).id, assigns(:team).id
      assert_redirected_to '/'
    end
  end
  
  def test_destroy_should_unauth
    login_as :mike2
    assert_no_difference('TeamJoinRequest.count') do
      delete :destroy, :id => 5
      assert_redirected_to '/'
    end
  end
  
  def test_destroy
    login_as :mike1
    c1 = TeamJoinRequest.count
    c2 = TeamJoinRequest.count :conditions=>["user_id = ?", users(:mike1).id]
    delete :destroy, :id => 5, :back_uri => '/public'
    assert_redirected_to '/public'#team_join_invitations_path
    assert_equal c1-1, TeamJoinRequest.count
    assert_equal c2-1, (TeamJoinRequest.count :conditions=>["user_id = ?", users(:mike1).id])
  end
end

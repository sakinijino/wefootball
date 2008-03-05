require File.dirname(__FILE__) + '/../test_helper'

class TeamJoinRequestsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  include AuthenticatedTestHelper

  def test_index_unlogin
    get :index, :team_id=>teams(:inter).id
    assert_redirected_to new_session_path
  end
  
  def test_index_team_requests
    login_as :saki
    get :index, :team_id=>teams(:inter).id
    assert_template 'index_user'
    assert_equal 1, assigns(:requests).length
  end
  
  def test_index_user_requests
    login_as :mike2
    get :index, :user_id=>users(:mike2)
    assert_template 'index_team'
    assert_equal 1, assigns(:requests).length
  end
  
  def test_create_request
    assert_difference('TeamJoinRequest.count') do
      assert_difference('TeamJoinRequest.count :conditions=>["user_id = ?", users(:mike1).id]') do
        login_as :mike1
        post :create, :team_join_request => { 
          :user_id => users(:mike1).id, 
          :team_id => teams(:inter).id,
          :message => 'hello'
        }
        assert_equal 'hello', assigns(:tjs).message
      end
    end
  end
  
  def test_create_request_should_be_yourself
    assert_no_difference('TeamJoinRequest.count') do
      login_as :saki
      post :create, :team_join_request => { 
        :user_id => users(:mike3).id, 
        :team_id => teams(:inter).id,
        :message => 'hello'
      }
      assert_redirected_to '/'
    end
  end
  
  def test_create_request_should_not_in_team
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
  
  def test_create_request_twice_with_long_message
    assert_no_difference('TeamJoinRequest.count') do
      login_as :mike2
      post :create, :team_join_request => { 
        :user_id => users(:mike2).id, 
        :team_id => teams(:inter).id,
        :message => 'hello'*1000
      }
      assert_equal 150, assigns(:tjs).message.length
    end
  end
  
  def test_destroy_unauth
    login_as :mike1
    assert_no_difference('TeamJoinRequest.count') do
      delete :destroy, :id => 6
      assert_redirected_to '/'
    end
  end
  
  def test_destroy
    login_as :saki
    c1 = TeamJoinRequest.count
    c2 = TeamJoinRequest.count :conditions=>["user_id = ?", users(:mike2).id]
    delete :destroy, :id => 6, :back_uri => '/public'
    assert_redirected_to '/public'#team_team_join_requests_path(assigns(:tjs).team.id)
    assert_equal c1-1, TeamJoinRequest.count
    assert_equal c2-1, (TeamJoinRequest.count :conditions=>["user_id = ?", users(:mike2).id])
  end
end

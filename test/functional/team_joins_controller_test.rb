require File.dirname(__FILE__) + '/../test_helper'

class TeamJoinsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  include AuthenticatedTestHelper
  
  fixtures :users, :teams
  
  def setup
    @request    = ActionController::TestRequest.new
    @request.env["HTTP_ACCEPT"] = "application/xml"
    @response   = ActionController::TestResponse.new
  end
  
  def test_accept_invitation
    login_as :mike1
    assert_difference('UserTeam.count') do
      assert_difference('User.find(users(:mike1).id).teams.length') do
        post :create, :id=>5
        assert_response 200
      end
    end
  end
  
  def test_accept_request
    login_as :saki
    assert_difference('UserTeam.count') do
      assert_difference('User.find(users(:mike2).id).teams.length') do
        post :create, :id=>6
        assert_response 200
      end
    end
  end
  
  def test_invitaion_unauth
    login_as :saki
    assert_no_difference('UserTeam.count') do
      assert_no_difference('User.find(users(:mike1).id).teams.length') do
        post :create, :id=>5
        assert_response 401
      end
    end
  end
  
  def test_request_unauth
    login_as :mike2
    assert_no_difference('UserTeam.count') do
      assert_no_difference('User.find(users(:mike2).id).teams.length') do
        post :create, :id=>6
        assert_response 401
      end
    end
  end
  
  def test_update
    login_as :saki
    assert_difference('Team.find(teams(:milan)).users.admin.length') do
      put :update, :user_id=>users(:aaron).id, :team_id=>teams(:milan).id, :team_join=>{:is_admin => true}
      assert_response 200
    end
  end
  
  def test_update_unauth
    login_as :mike2
    assert_no_difference('Team.find(teams(:milan)).users.admin.length') do
      put :update, :user_id=>users(:aaron).id, :team_id=>teams(:milan).id, :team_join=>{:is_admin => true}
      assert_response 401
    end
  end
  
  def test_update_should_not_update_user_id_and_team_id
    login_as :saki
    assert_no_difference('Team.find(teams(:milan)).users.length') do
      assert_no_difference('Team.find(teams(:inter)).users.length') do
        put :update, :user_id=>users(:saki).id, :team_id=>teams(:milan).id, 
          :team_join=>{:user_id=>users(:aaron).id, :team_id=>teams(:inter).id, :is_admin => false}
        assert_response 200
      end
    end
  end
  
  def test_destroy_unauth
    login_as :mike2
    delete :destroy, :user_id=>users(:aaron).id, :team_id=>teams(:milan).id
    assert_response 401
  end
  
  def test_destroy
    login_as :saki
    c = UserTeam.count
    delete :destroy, :user_id=>users(:aaron).id, :team_id=>teams(:milan).id
    assert_response 200
    assert_equal c-1, UserTeam.count
  end
end

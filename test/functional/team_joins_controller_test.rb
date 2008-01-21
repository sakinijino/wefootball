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
end

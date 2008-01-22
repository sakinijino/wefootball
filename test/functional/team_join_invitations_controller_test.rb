require File.dirname(__FILE__) + '/../test_helper'

class TeamJoinInvitationsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  include AuthenticatedTestHelper
  
  fixtures :users, :teams
  
  def setup
    @request    = ActionController::TestRequest.new
    @request.env["HTTP_ACCEPT"] = "application/xml"
    @response   = ActionController::TestResponse.new
  end
  
  def test_index_user_invitations
    login_as :mike1
    get :index, :user_id=>users(:saki).id
    assert_response 200
    assert_select 'message', 'Hello'
    assert_not_nil(find_tag(:tag=>'apply_date'))
    assert_select 'team>id', teams(:inter).id.to_s
  end
  
  def test_index_team_invitations
    login_as :mike1
    get :index, :team_id=>teams(:inter).id
    assert_response 200
    assert_select 'message', 'Hello'
    assert_not_nil(find_tag(:tag=>'apply_date'))
    assert_select 'user>id', users(:saki).id.to_s
  end
  
  def test_create_invitation
    assert_difference('TeamJoinRequest.count') do
      assert_difference('users(:mike1).invited_join_teams.length') do
        login_as :saki
        post :create, :team_join_request => { 
          :user_id => users(:mike1).id, 
          :team_id => teams(:inter).id,
          :message => 'hello'
        }
        assert_response 200
        assert_select 'message', 'hello'
      end
    end
  end
  
  def test_create_request_should_be_admin
    assert_no_difference('TeamJoinRequest.count') do
      login_as :mike1
      post :create, :team_join_request => { 
        :user_id => users(:mike1).id, 
        :team_id => teams(:inter).id,
        :message => 'hello'
      }
      assert_response 401
    end
  end
  
  def test_create_request_should_not_in_team
    assert_no_difference('TeamJoinRequest.count') do
      login_as :saki
      post :create, :team_join_request => { 
        :user_id => users(:saki).id, 
        :team_id => teams(:inter).id,
        :message => 'hello'
      }
      assert_response 400
    end
  end
  
  def test_long_message_error
    assert_no_difference('TeamJoinRequest.count') do
      login_as :saki
      post :create, :team_join_request => { 
        :user_id => users(:mike1).id, 
        :team_id => teams(:inter).id,
        :message => 'hello'*1000
      }
      assert_response 200
      assert_not_nil find_tag(:tag=>"error", :attributes=>{:field=>"message"})
    end
  end
  
  def test_destroy_should_unauth
    login_as :mike2
    assert_no_difference('TeamJoinRequest.count') do
      delete :destroy, :id => 5
      assert_response 401
    end
  end
  
  def test_destroy
    login_as :mike1
    c1 = TeamJoinRequest.count
    c2 = users(:mike1).invited_join_teams.length
    delete :destroy, :id => 5
    assert_response 200
    assert_equal c1-1, TeamJoinRequest.count
    assert_equal c2-1, users(:mike1).invited_join_teams.length
  end
end

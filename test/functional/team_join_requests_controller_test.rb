require File.dirname(__FILE__) + '/../test_helper'

class TeamJoinRequestsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  include AuthenticatedTestHelper
  
  fixtures :users, :teams
  
  def setup
    @request    = ActionController::TestRequest.new
    @request.env["HTTP_ACCEPT"] = "application/xml"
    @response   = ActionController::TestResponse.new
  end

  def test_index_team_requests
    login_as :mike1
    get :index, :team_id=>teams(:inter).id
    assert_response 200
    assert_select 'apply_date', team_join_requests(:mike2_inter).apply_date.to_s(:flex)
    assert_select 'user>id', users(:mike2).id.to_s
  end
  
  def test_index_user_requests
    login_as :mike1
    get :index, :user_id=>users(:mike2)
    assert_response 200
    assert_select 'apply_date', team_join_requests(:mike2_inter).apply_date.to_s(:flex)
    assert_select 'team>id', teams(:inter).id.to_s
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
        assert_response 200
        assert_select 'message', 'hello'
      end
    end
  end
  
  def test_create_request_should_be_yourself
    assert_no_difference('TeamJoinRequest.count') do
      login_as :saki
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
      login_as :mike2
      post :create, :team_join_request => { 
        :user_id => users(:mike2).id, 
        :team_id => teams(:inter).id,
        :message => 'hello'*1000
      }
      assert_not_nil find_tag(:tag=>"error", :attributes=>{:field=>"message"})
    end
  end
  
  def test_destroy_unauth
    login_as :mike1
    assert_no_difference('TeamJoinRequest.count') do
      delete :destroy, :id => 6
      assert_response 401
    end
  end
  
  def test_destroy
    login_as :saki
    c1 = TeamJoinRequest.count
    c2 = TeamJoinRequest.count :conditions=>["user_id = ?", users(:mike2).id]
    delete :destroy, :id => 6
    assert_response 200
    assert_equal c1-1, TeamJoinRequest.count
    assert_equal c2-1, (TeamJoinRequest.count :conditions=>["user_id = ?", users(:mike2).id])
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class TeamsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = TeamsController.new
    @request    = ActionController::TestRequest.new
    @request.env["HTTP_ACCEPT"] = "application/xml"
    @response   = ActionController::TestResponse.new
  end
  
  def test_create_team
    assert_difference('Team.count') do
      assert_difference('users(:saki).teams.admin.length') do
        login_as :saki
        post :create, :team => { :name=>'Inter Milan', :shortname=>'inter'}
        assert_select "name", "Inter Milan"
      end      
    end
  end
  
  def test_should_login_before_create_team
    post :create, :team => { :name=>'Inter Milan', :shortname=>'inter'}
    assert_response 401
  end
  
  def test_create_team_error
    assert_no_difference('Team.count') do
      assert_no_difference('users(:saki).teams.admin.length') do
        login_as :saki
        post :create, :team => { :name=>'Inter Milan'*100, :shortname=>'inter'}
        assert_not_nil find_tag(:tag=>"error", :attributes=>{:field=>"name"})
        assert_response 200
      end      
    end
  end
  
  def test_should_show_team
    get :show, :id => teams(:inter).id
    assert_select "found_time", "01/21/2008"
    assert_select "name", "Inter Milan"
    assert_response :success
  end
  
  def test_show_team_error
    get :show, :id => -1
    assert_response 404
  end
  
  def test_should_update_team
    login_as :saki
    put :update, :id => teams(:inter).id, :team => {:name => "Inter"}
    assert_select "name", "Inter"
    assert_response :success
  end
  
  def test_should_update_team_error
    login_as :saki
    put :update, :id => teams(:inter).id, :team => {:name=>'Inter Milan'*100}
    assert_not_nil find_tag(:tag=>"error", :attributes=>{:field=>"name"})
    assert_response 400
  end
  
 def test_update_unfound_team
    login_as :saki
    put :update, :id => -1, :team => {:name => "Inter"}
    assert_response 404
  end
  
  def test_should_be_admin_update_team
    login_as :aaron
    put :update, :id => teams(:inter).id, :team => {:name => "Inter"}
    assert_response 401
  end
  
  def test_should_get_user_teams_index
    get :index, :user_id => users(:saki).id
    assert_response 200
    assert_select "team", :count=>2
  end
#
#  def test_should_destroy_team
#    assert_difference('Team.count', -1) do
#      delete :destroy, :id => teams(:one).id
#    end
#
#    assert_redirected_to teams_path
#  end
end

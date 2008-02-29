require File.dirname(__FILE__) + '/../test_helper'

class TeamsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  def test_create_team
    assert_difference('Team.count') do
      assert_difference('users(:saki).teams.admin.length') do
        login_as :saki
        post :create, :team => { :name=>'Inter Milan', :shortname=>'inter'}
        assert_redirected_to team_view_path(assigns(:team).id)
      end      
    end
  end
  
  def test_should_login_before_create_team
    post :create, :team => { :name=>'Inter Milan', :shortname=>'inter'}
    assert_redirected_to new_session_path
  end
  
  def test_create_team_error
    assert_no_difference('Team.count') do
      assert_no_difference('users(:saki).teams.admin.length') do
        login_as :saki
        post :create, :team => { :name=>'Inter Milan'*100, :shortname=>'inter'}
        assert assigns(:team).errors.on(:name)
        assert_template 'new'
      end      
    end
  end
  
  def test_should_update_team
    login_as :saki
    put :update, :id => teams(:inter).id, :team => {:name => "Inter"}
    assert_equal "Inter", assigns(:team).name
    assert_redirected_to edit_team_path(teams(:inter).id)
  end
  
  def test_should_update_team_error
    login_as :saki
    put :update, :id => teams(:inter).id, :team => {:name=>'Inter Milan'*100}
    assert assigns(:team).errors.on(:name)
    assert_template 'edit'
  end
  
  def test_should_be_admin_update_team
    login_as :aaron
    put :update, :id => teams(:inter).id, :team => {:name => "Inter"}
    assert_redirected_to '/'
  end
  
  def test_should_get_user_admin_teams
    get :admin, :user_id => users(:saki).id
    assert_equal 2, assigns(:teamsList).length
    assert_template "index"
    get :admin, :user_id => users(:aaron).id
    assert_equal 0, assigns(:teamsList).length
    assert_template "index"
  end
end

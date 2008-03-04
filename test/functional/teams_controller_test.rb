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
  
  def test_should_not_create_team_unlogined
    post :create, :team => { :name=>'Inter Milan', :shortname=>'inter'}
    assert_redirected_to new_session_path
  end
  
  def test_should_update_team
    login_as :saki
    put :update, :id => teams(:inter).id, :team => {:name => "Inter"}
    assert_equal "Inter", assigns(:team).name
    assert_redirected_to edit_team_path(teams(:inter).id)
  end
  
  def test_update_team_with_long_name
    login_as :saki
    put :update, :id => teams(:inter).id, :team => {:name=>'Inter Milan'*100}
    assert_equal 50, assigns(:team).name.length
    assert_redirected_to edit_team_path(teams(:inter).id)
  end
  
  def test_should_not_update_team_if_user_is_not_admin
    login_as :aaron
    put :update, :id => teams(:inter).id, :team => {:name => "Inter"}
    assert_redirected_to '/'
  end
end

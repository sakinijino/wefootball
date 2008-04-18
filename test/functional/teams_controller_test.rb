require File.dirname(__FILE__) + '/../test_helper'

class TeamsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  def test_admin_limit_check
    UserTeam.destroy_all
    Team.destroy_all
    teams_array = []
    (1..21).each do |i|
       teams_array << Team.create(:name => 'Test', :shortname => 'test')
    end
    assert_equal 0, UserTeam.count
    assert_equal 21, Team.count
    (0..19).each do |i|
      ut = UserTeam.new(:is_admin => true)
      ut.user_id = users(:saki).id
      ut.team_id = teams_array[i].id
      ut.save!
    end
    login_as :saki
    get :new
    assert_redirected_to user_view_path(users(:saki).id)
    assert_no_difference('users(:saki).teams.admin.length') do
      post :create, :team => { :name=>'Inter Milan', :shortname=>'inter'}
      assert_redirected_to user_view_path(users(:saki).id)
    end   
  end
  
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
  
  def test_update_team_with_long_style
    login_as :saki
    put :update, :id => teams(:inter).id, :team => {:style=>'Inter Milan'*100}
    assert_equal 50, assigns(:style).name.length
    assert_redirected_to edit_team_path(teams(:inter).id)
  end
  
  def test_should_not_get_edit_if_user_is_not_admin
    login_as :aaron
    get :edit, :id => teams(:inter).id
    assert_redirected_to '/'
  end
  
  def test_should_not_update_team_if_user_is_not_admin
    login_as :aaron
    put :update, :id => teams(:inter).id, :team => {:name => "Inter"}
    assert_redirected_to '/'
  end
  
  def test_should_not_update_image_if_user_is_not_admin
    login_as :aaron
    put :update_image, :id => teams(:inter).id, :team => {}
    assert_redirected_to '/'
  end
end

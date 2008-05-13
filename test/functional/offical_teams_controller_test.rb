require File.dirname(__FILE__) + '/../test_helper'

class OfficalTeamsControllerTest < ActionController::TestCase
  def test_should_not_get_new_if_not_editor
    login_as :aaron
    get :new
    assert_fake_redirected
  end
  
  def test_create_team
    login_as :saki
    assert_difference('OfficalTeam.count') do
      assert_difference('users(:saki).offical_teams.reload.size') do
        post :create, :offical_team => { :name=>'Inter Milan'}
        assert_redirected_to edit_offical_team_path(assigns(:offical_team).id)
      end      
    end
  end
  
  def test_should_not_create_team_unlogined
    post :create, :offical_team => { :name=>'Inter Milan'}
    assert_redirected_to new_session_path
  end
  
  def test_should_not_create_team_if_not_editor
    login_as :mike1
    post :create, :offical_team => { :name=>'Inter Milan'}
    assert_fake_redirected
  end
  
  def test_should_update_team
    login_as :saki
    put :update, :id => offical_teams(:inter).id, :offical_team => {:name => "国际米兰"}
    assert_equal "国际米兰", assigns(:offical_team).name
    assert_redirected_to edit_offical_team_path(offical_teams(:inter).id)
  end
  
  def test_should_not_get_edit_if_not_editor
    login_as :aaron
    get :edit, :id => offical_teams(:inter).id
    assert_fake_redirected
  end
  
  def test_should_not_update_team_if_not_editor
    login_as :aaron
    put :update, :id => offical_teams(:inter).id, :offical_team => {:name => "Inter"}
    assert_fake_redirected
  end
  
  def test_should_not_update_image_if_not_editor
    login_as :aaron
    put :update_image, :id => offical_teams(:inter).id, :offical_team => {}
    assert_fake_redirected
  end
end

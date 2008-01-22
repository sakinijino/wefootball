require File.dirname(__FILE__) + '/../test_helper'

class TrainingsControllerTest < ActionController::TestCase
  def test_should_get_team_index
    login_as :saki
    get :index, :team_id => teams(:inter)
    assert_response :success
    assert_select 'training', :count => 2
    assert_select 'start_time', :count => 2
  end

  def test_should_create_training
    login_as :saki
    assert_difference('Training.count') do
      post :create, :training => { :team_id => teams(:inter).id }
      assert_response :success
      assert_select 'training', :count => 1
    end
  end
  
  def test_should_be_admin_before_create_training
    login_as :mike1
    assert_no_difference('Training.count') do
      post :create, :training => { :team_id => teams(:inter).id }
      assert_response 401
    end
  end

  def test_should_show_training
    login_as :saki
    get :show, :id => trainings(:training1).id
    assert_response :success
  end
  
  def test_should_update_training
    login_as :saki
    t = DateTime.now
    put :update, :id => trainings(:training1).id, :training => { :start_time=> t}
    assert_response :success
    assert_select "start_time", t.to_s
  end
  
  def test_should_be_admin_before_update_training
    login_as :mike1
    t = Time.now
    put :update, :id => trainings(:training1).id, :training => { :start_time=> t}
    assert_response 401
  end
  
  def test_should_not_modify_teamid_when_update_training
    login_as :saki
    t = Time.now
    put :update, :id => trainings(:training1).id, :training => { :team_id=>teams(:milan).id, :start_time=> t}
    assert_response 200
    assert_select "team_id", teams(:inter).id.to_s
  end

  def test_should_destroy_training
    login_as :saki
    assert_difference('Training.count', -1) do
      delete :destroy, :id => trainings(:training1).id
      assert_response :success
    end
  end
  
  def test_should_be_admin_before_destroy_training
    login_as :mike1
    assert_no_difference('Training.count', -1) do
      delete :destroy, :id => trainings(:training1).id
      assert_response 401
    end
  end
end

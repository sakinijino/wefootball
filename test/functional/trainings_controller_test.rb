require File.dirname(__FILE__) + '/../test_helper'

class TrainingsControllerTest < ActionController::TestCase
  def test_should_get_team_index
    get :index, :team_id => teams(:inter)
    assert_template "index_team"
    assert_equal 2, assigns(:trainings).length
  end
  
  def test_should_get_user_index
    get :index, :user_id => users(:saki)
    assert_template "index_user"
    assert_equal 2, assigns(:trainings).length
  end

  def test_should_create_training
    login_as :saki
    assert_difference('Training.count') do
      post :create, :training => { :team_id => teams(:inter).id }
      assert_redirected_to training_view_path(assigns(:training))
    end
  end
  
  def test_should_be_admin_before_create_training
    login_as :mike1
    assert_no_difference('Training.count') do
      post :create, :training => { :team_id => teams(:inter).id }
      assert_redirected_to '/'
    end
  end
  
  def test_should_update_training
    login_as :saki
    t = Time.now.tomorrow.at_midnight.since(3600)
    put :update, :id => trainings(:training1).id, 
      :start_time => {
        :year => t.year.to_s,
        :month => t.month.to_s,
        :day => t.day.to_s,
        :hour => t.hour.to_s,
        :minute => t.min.to_s
      },
      :end_time => {
        :hour => (t.hour+2).to_s,
        :minute => t.min.to_s
      }
    assert_redirected_to training_view_path(assigns(:training))
    assert_equal t.to_s, Training.find(trainings(:training1).id).start_time.to_s
  end
  
  def test_should_be_admin_before_update_training
    login_as :mike1
    t = Time.now
    put :update, :id => trainings(:training1).id, :training => { :start_time=> t}
    assert_redirected_to '/'
  end

  def test_should_destroy_training
    login_as :saki
    assert_difference('Training.count', -1) do
      delete :destroy, :id => trainings(:training1).id
      assert_redirected_to team_view_path(assigns(:training).team)
    end
  end
  
  def test_should_be_admin_before_destroy_training
    login_as :mike1
    assert_no_difference('Training.count') do
      delete :destroy, :id => trainings(:training1).id
      assert_redirected_to '/'
    end
  end
end

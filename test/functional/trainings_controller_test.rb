require File.dirname(__FILE__) + '/../test_helper'

class TrainingsControllerTest < ActionController::TestCase
  def test_should_create_training
    login_as :saki
    assert_difference('TrainingJoin.count', teams(:inter).users.size) do
    assert_difference('Training.count') do
      post :create, :training => { :team_id => teams(:inter).id, :location=>"School" }
      assert_redirected_to training_view_path(assigns(:training))
    end
    end
    
    assert_equal teams(:inter).users.size, assigns(:training).users.undetermined.size
    assert_equal 0, assigns(:training).users.joined.size
  end
  
  def test_should_be_admin_before_create_training
    login_as :mike1
    assert_no_difference('Training.count') do
      post :create, :training => { :team_id => teams(:inter).id }
      assert_redirected_to '/'
    end
  end
  
  def test_should_update_training
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
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
  
  def test_should_not_update_training_after_it_started
    trainings(:training1).start_time = Time.now.ago(1800)
    trainings(:training1).end_time = Time.now.since(3600)
    trainings(:training1).save_without_validation!
    login_as :mike1
    t = Time.now
    put :update, :id => trainings(:training1).id, :training => { :start_time=> t}
    assert_redirected_to '/'
  end
  
  def test_should_be_admin_before_update_training
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    login_as :mike1
    t = Time.now
    put :update, :id => trainings(:training1).id, :training => { :start_time=> t}
    assert_redirected_to '/'
  end

  def test_should_destroy_training
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    login_as :saki
    assert_difference('Training.count', -1) do
      delete :destroy, :id => trainings(:training1).id
      assert_redirected_to team_view_path(assigns(:training).team)
    end
  end
  
  def test_should_not_destroy_training_after_it_started
    trainings(:training1).start_time = Time.now.ago(1800)
    trainings(:training1).end_time = Time.now.since(3600)
    trainings(:training1).save_without_validation!
    login_as :mike1
    assert_no_difference('Training.count') do
      delete :destroy, :id => trainings(:training1).id
      assert_redirected_to '/'
    end
  end
  
  def test_should_be_admin_before_destroy_training
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    login_as :mike1
    assert_no_difference('Training.count') do
      delete :destroy, :id => trainings(:training1).id
      assert_redirected_to '/'
    end
  end
end

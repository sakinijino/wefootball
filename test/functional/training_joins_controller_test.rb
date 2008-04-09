require File.dirname(__FILE__) + '/../test_helper'

class TrainingJoinsControllerTest < ActionController::TestCase
  def test_should_create_training_join
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    login_as :quentin
    assert_difference('TrainingJoin.count') do
      post :create, :training_id=>trainings(:training1).id
      assert_redirected_to training_path(assigns(:training).id)
    end
  end
  
  def test_should_create_training_join_with_an_undetermined_join
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    tj = TrainingJoin.new
    tj.user = users(:quentin)
    tj.training = trainings(:training1)
    tj.status = TrainingJoin::UNDETERMINED
    tj.save!
    
    login_as :quentin
    assert_no_difference('TrainingJoin.count') do
      post :create, :training_id=>trainings(:training1).id
      assert_redirected_to training_path(assigns(:training).id)
      assert_equal TrainingJoin::JOIN, tj.reload.status
    end
  end
  
  def test_should_not_join_when_training_finished_3_days
    trainings(:training1).start_time = 3.days.ago.ago(7200)
    trainings(:training1).end_time = 3.days.ago.ago(3600)
    trainings(:training1).save_without_validation!
    login_as :quentin
    assert_no_difference('TrainingJoin.count') do
      post :create, :training_id=>trainings(:training1).id
      assert_redirected_to '/'
    end
  end
  
  def test_should_not_join_when_is_not_a_member_of_team
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    login_as :aaron
    assert_no_difference('TrainingJoin.count') do
      post :create, :training_id=>trainings(:training1).id
      assert_redirected_to '/'
    end
  end
  
  def test_should_not_join_twice
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    login_as :saki
    assert_no_difference('TrainingJoin.count') do
      post :create, :training_id=>trainings(:training1).id
      assert_redirected_to training_path(assigns(:training).id)
    end
  end

  def test_should_destroy_training_join
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    login_as :saki
    assert_difference('TrainingJoin.count', -1) do
      delete :destroy, :training_id => trainings(:training1).id
      assert_redirected_to training_path(trainings(:training1).id)
    end
  end
  
  def test_should_destroy_training_join_with_an_undetermined_join
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    tj = TrainingJoin.new
    tj.user = users(:quentin)
    tj.training = trainings(:training1)
    tj.status = TrainingJoin::UNDETERMINED
    tj.save!
    
    login_as :quentin
    assert_difference('TrainingJoin.count', -1) do
      delete :destroy, :training_id=>trainings(:training1).id
      assert_redirected_to training_path(assigns(:training).id)
    end
  end
  
  def test_should_not_destroy_training_join_when_it_started
    trainings(:training1).start_time = Time.now.ago(1800)
    trainings(:training1).end_time = Time.now.since(1800)
    trainings(:training1).save_without_validation!
    login_as :saki
    assert_no_difference('TrainingJoin.count', -1) do
      delete :destroy, :training_id => trainings(:training1).id
      assert_redirected_to '/'
    end
  end
  
  def test_should_not_destroy_training_join_when_not_joined
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    login_as :quentin
    assert_no_difference('TrainingJoin.count') do
      delete :destroy, :training_id => trainings(:training1).id
      assert_redirected_to '/'
    end
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class TrainingJoinsControllerTest < ActionController::TestCase
  def test_should_create_training_join
    login_as :quentin
    assert_difference('TrainingJoin.count') do
      post :create, :training_join => { :user_id=>users(:quentin).id, :training_id=>trainings(:training1).id}
      assert_response :success
    end
  end
  
  def test_should_create_can_not_join
    login_as :aaron
    assert_no_difference('TrainingJoin.count') do
      post :create, :training_join => { :user_id=>users(:aaron).id, :training_id=>trainings(:training1).id}
      assert_response 401
    end
  end
  
  def test_should_create_unauth
    login_as :saki
    assert_no_difference('TrainingJoin.count') do
      post :create, :training_join => { :user_id=>users(:quentin).id, :training_id=>trainings(:training1).id}
      assert_response 401
    end
  end
  
  def test_join_twice
    login_as :saki
    assert_no_difference('TrainingJoin.count') do
      post :create, :training_join => { :user_id=>users(:saki).id, :training_id=>trainings(:training1).id}
      assert_response 200
    end
  end

  def test_should_destroy_training_join
    login_as :saki
    assert_difference('TrainingJoin.count', -1) do
      delete :destroy, :user_id => users(:saki).id, :training_id => trainings(:training1).id
      assert_response 200
    end
  end
  
  def test_should_destroy_training_join_unauth
    login_as :quentin
    assert_no_difference('TrainingJoin.count') do
      delete :destroy, :user_id => users(:saki).id, :training_id => trainings(:training1).id
      assert_response 401
    end
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class TrainingJoinsControllerTest < ActionController::TestCase
  def test_should_create_training_join
    login_as :quentin
    assert_difference('TrainingJoin.count') do
      post :create, :user_id=>users(:quentin).id, :training_id=>trainings(:training1).id
      assert_redirected_to training_view_path(assigns(:training).id)
    end
  end
  
  def test_should_join_when_is_a_member_of_team
    login_as :aaron
    assert_no_difference('TrainingJoin.count') do
      post :create, :user_id=>users(:aaron).id, :training_id=>trainings(:training1).id
      assert_redirected_to '/'
    end
  end
  
  def test_should_not_join_twice
    login_as :saki
    assert_no_difference('TrainingJoin.count') do
      post :create, :user_id=>users(:saki).id, :training_id=>trainings(:training1).id
      assert_redirected_to training_view_path(assigns(:training).id)
    end
  end

  def test_should_destroy_training_join
    login_as :saki
    assert_difference('TrainingJoin.count', -1) do
      delete :destroy, :user_id => users(:saki).id, :training_id => trainings(:training1).id
      assert_redirected_to training_view_path(trainings(:training1).id)
    end
  end
  
  def test_should_not_destroy_training_join_unauth
    login_as :mike3
    assert_no_difference('TrainingJoin.count') do
      delete :destroy, :user_id => users(:saki).id, :training_id => trainings(:training1).id
    end
  end
end

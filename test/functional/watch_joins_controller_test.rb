require File.dirname(__FILE__) + '/../test_helper'

class WatchJoinsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:watch_joins)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_watch_join
    assert_difference('WatchJoin.count') do
      post :create, :watch_join => { }
    end

    assert_redirected_to watch_join_path(assigns(:watch_join))
  end

  def test_should_show_watch_join
    get :show, :id => watch_joins(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => watch_joins(:one).id
    assert_response :success
  end

  def test_should_update_watch_join
    put :update, :id => watch_joins(:one).id, :watch_join => { }
    assert_redirected_to watch_join_path(assigns(:watch_join))
  end

  def test_should_destroy_watch_join
    assert_difference('WatchJoin.count', -1) do
      delete :destroy, :id => watch_joins(:one).id
    end

    assert_redirected_to watch_joins_path
  end
end

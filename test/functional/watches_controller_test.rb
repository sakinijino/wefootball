require File.dirname(__FILE__) + '/../test_helper'

class WatchesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:watches)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_watch
    assert_difference('Watch.count') do
      post :create, :watch => { }
    end

    assert_redirected_to watch_path(assigns(:watch))
  end

  def test_should_show_watch
    get :show, :id => watches(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => watches(:one).id
    assert_response :success
  end

  def test_should_update_watch
    put :update, :id => watches(:one).id, :watch => { }
    assert_redirected_to watch_path(assigns(:watch))
  end

  def test_should_destroy_watch
    assert_difference('Watch.count', -1) do
      delete :destroy, :id => watches(:one).id
    end

    assert_redirected_to watches_path
  end
end

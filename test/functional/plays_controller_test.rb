require File.dirname(__FILE__) + '/../test_helper'

class PlaysControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:plays)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_play
    assert_difference('Play.count') do
      post :create, :play => { }
    end

    assert_redirected_to play_path(assigns(:play))
  end

  def test_should_show_play
    get :show, :id => plays(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => plays(:one).id
    assert_response :success
  end

  def test_should_update_play
    put :update, :id => plays(:one).id, :play => { }
    assert_redirected_to play_path(assigns(:play))
  end

  def test_should_destroy_play
    assert_difference('Play.count', -1) do
      delete :destroy, :id => plays(:one).id
    end

    assert_redirected_to plays_path
  end
end

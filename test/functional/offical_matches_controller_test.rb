require File.dirname(__FILE__) + '/../test_helper'

class OfficalMatchesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:offical_matches)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_offical_match
    assert_difference('OfficalMatch.count') do
      post :create, :offical_match => { }
    end

    assert_redirected_to offical_match_path(assigns(:offical_match))
  end

  def test_should_show_offical_match
    get :show, :id => offical_matches(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => offical_matches(:one).id
    assert_response :success
  end

  def test_should_update_offical_match
    put :update, :id => offical_matches(:one).id, :offical_match => { }
    assert_redirected_to offical_match_path(assigns(:offical_match))
  end

  def test_should_destroy_offical_match
    assert_difference('OfficalMatch.count', -1) do
      delete :destroy, :id => offical_matches(:one).id
    end

    assert_redirected_to offical_matches_path
  end
end

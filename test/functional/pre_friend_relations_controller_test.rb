require File.dirname(__FILE__) + '/../test_helper'

class PreFriendRelationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pre_friend_relations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_pre_friend_relation
    assert_difference('PreFriendRelation.count') do
      post :create, :pre_friend_relation => { }
    end

    assert_redirected_to pre_friend_relation_path(assigns(:pre_friend_relation))
  end

  def test_should_show_pre_friend_relation
    get :show, :id => pre_friend_relations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => pre_friend_relations(:one).id
    assert_response :success
  end

  def test_should_update_pre_friend_relation
    put :update, :id => pre_friend_relations(:one).id, :pre_friend_relation => { }
    assert_redirected_to pre_friend_relation_path(assigns(:pre_friend_relation))
  end

  def test_should_destroy_pre_friend_relation
    assert_difference('PreFriendRelation.count', -1) do
      delete :destroy, :id => pre_friend_relations(:one).id
    end

    assert_redirected_to pre_friend_relations_path
  end
end

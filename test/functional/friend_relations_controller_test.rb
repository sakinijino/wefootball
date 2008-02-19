require File.dirname(__FILE__) + '/../test_helper'

class FriendRelationsControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :mike1
    get :index, :user_id=>users(:saki).id
    assert_response :success
    assert_select "friend", 2
    assert_select "nickname", "mike2"
  end

  def test_should_create_friend_relation
    login_as :aaron
    assert_difference('FriendRelation.count') do
      assert_difference('FriendInvitation.count', -1) do
        post :create, :request_id => friend_invitations(:mike2_to_aaron).id
        assert_response :success
      end
    end
  end
  
  def test_should_create_friend_relation_twice
    @req1 = FriendRelation.create(:user1_id => users(:mike2).id, :user2_id => users(:aaron).id)
    login_as :aaron
    assert_no_difference('FriendRelation.count') do
      assert_difference('FriendInvitation.count', -1) do
        post :create, :request_id => friend_invitations(:mike2_to_aaron).id
        assert_response :success
      end
    end
  end
  
  def test_should_create_friend_relation_error
    login_as :saki
    assert_no_difference('FriendRelation.count') do
      assert_no_difference('FriendInvitation.count') do
        post :create, :request_id => friend_invitations(:mike2_to_aaron).id
        assert_response 401
      end
    end
  end

  def test_should_destroy_friend_relation
    login_as :saki
    assert_difference('FriendRelation.count', -1) do
      delete :destroy, :user_id => users(:aaron).id
      assert_response 200
    end
    assert_difference('FriendRelation.count', -1) do
      delete :destroy, :user_id => users(:mike2).id
      assert_response 200
    end
  end
end

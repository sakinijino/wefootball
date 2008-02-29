require File.dirname(__FILE__) + '/../test_helper'

class FriendInvitationsControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :aaron
    get :index
    assert 2, assigns(:friend_invitations).length
    assert_template 'index'
  end

  def test_should_create_friend_invitation
    login_as :mike1
    assert_difference('FriendInvitation.count') do
      post :create, :friend_invitation => {
        :host_id=>users(:saki).id,
        :message=>"Hi"
      }
      assert_redirected_to user_view_path(users(:saki).id)
    end
  end
  
  def test_should_create_friend_invitation_twice
    login_as :mike2
    assert_no_difference('FriendInvitation.count') do
      post :create, :friend_invitation => {
        :host_id =>users(:aaron).id,
        :message=>"Hello"
      }
      assert_redirected_to user_view_path(users(:aaron).id)
      assert_equal "Hello", assigns(:friend_invitation).message
    end
  end
  
  def test_should_create_friend_invitation_twice_error
    login_as :mike2
    assert_no_difference('FriendInvitation.count') do
      post :create, :friend_invitation => {
        :host_id =>users(:aaron).id,
        :message=>"Hello"*1000
      }
      assert 500, assigns(:friend_invitation).message.length
    end
  end
  
  def test_should_create_friend_invitation_when_already_friends
    login_as :saki
    assert_no_difference('FriendInvitation.count') do
      post :create, :friend_invitation => {
        :host_id =>users(:mike2).id,
        :message=>"Hi"
      }
      assert_redirected_to user_view_path(users(:mike2).id)
    end
  end
  
  def test_should_create_friend_invitation_noauth
    login_as :saki
    assert_no_difference('FriendInvitation.count') do
      post :create, :friend_invitation => {
        :host_id =>users(:saki).id,
        :message=>"Hi"
      }
      assert_redirected_to '/'
    end
  end
  
  def test_should_create_friend_invitation_error
    login_as :saki
    assert_difference('FriendInvitation.count') do
      post :create, :friend_invitation => {
        :host_id =>users(:mike1).id,
        :message=>"Hi"*1000
      }
      assert 500, assigns(:friend_invitation).message.length
    end
  end

  def test_should_destroy_friend_invitation
    login_as :aaron
    assert_difference('FriendInvitation.count', -1) do
      delete :destroy, :id => friend_invitations(:quentin_to_aaron).id
    end
  end
  
  def test_should_destroy_friend_invitation_noauth
    login_as :quentin
    assert_no_difference('FriendInvitation.count') do
      delete :destroy, :id => friend_invitations(:quentin_to_aaron).id
    end
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class FriendInvitationsControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :aaron
    get :index
    assert_response :success
    assert_select "friend_invitation", 2
    assert_select "apply_date", "01/11/2008"
  end

  def test_should_create_friend_invitation
    login_as :mike1
    assert_difference('FriendInvitation.count') do
      post :create, :friend_invitation => {
        :host_id=>users(:saki).id,
        :message=>"Hi"
      }
      assert_response :success
    end
  end
  
  def test_should_create_friend_invitation_twice
    login_as :mike2
    assert_no_difference('FriendInvitation.count') do
      post :create, :friend_invitation => {
        :host_id =>users(:aaron).id,
        :message=>"Hello"
      }
      assert_response :success
      assert_select 'message', 'Hello'
    end
  end
  
  def test_should_create_friend_invitation_twice_error
    login_as :mike2
    assert_no_difference('FriendInvitation.count') do
      post :create, :friend_invitation => {
        :host_id =>users(:aaron).id,
        :message=>"Hello"*1000
      }
      assert_response :success
      tag = find_tag :tag=>"error", :attributes=>{:field=>"message"}
      assert_not_nil tag
    end
  end
  
  def test_should_create_friend_invitation_when_already_friends
    login_as :saki
    assert_no_difference('FriendInvitation.count') do
      post :create, :friend_invitation => {
        :host_id =>users(:mike2).id,
        :message=>"Hi"
      }
      assert_response 400
    end
  end
  
  def test_should_create_friend_invitation_noauth
    login_as :saki
    assert_no_difference('FriendInvitation.count') do
      post :create, :friend_invitation => {
        :host_id =>users(:saki).id,
        :message=>"Hi"
      }
      assert_response 400
    end
  end
  
  def test_should_create_friend_invitation_error
    login_as :saki
    assert_no_difference('FriendInvitation.count') do
      post :create, :friend_invitation => {
        :host_id =>users(:mike1).id,
        :message=>"Hi"*500
      }
      assert_response :success
      tag = find_tag :tag=>"error", :attributes=>{:field=>"message"}
      assert_not_nil tag
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

require File.dirname(__FILE__) + '/../test_helper'

class UserViewsControllerTest < ActionController::TestCase
  
  def test_show_unlogin
    users(:aaron).friend_invitations_count = 2
    users(:aaron).team_join_invitations_count = 1
    users(:aaron).save!
    get :show, :id => users(:aaron).id  # 未登录
    assert_select "#send_friend_invitation_div", 0
    assert_select "img[src*=breakUpFriendship]", 0
    assert_select "img[src*=inviteFriend]", 0
    assert_equal 0, assigns(:user_invitation_count)
    assert_equal 0, assigns(:team_invitation_count)
  end
  
  def test_show
    users(:aaron).friend_invitations_count = 2
    users(:aaron).team_join_invitations_count = 1
    users(:aaron).save!
    login_as :aaron    
    get :show, :id => users(:aaron).id # 自己
    assert_select "#send_friend_invitation_div", 0
    assert_select "img[src*=breakUpFriendship]", 0
    assert_select "img[src*=inviteFriend]", 0
    assert_equal 2, assigns(:user_invitation_count)
    assert_equal 1, assigns(:team_invitation_count)
    get :show, :id => users(:mike2).id # 有邀请的
    assert_select "#send_friend_invitation_div", 0
    assert_select "img[src*=breakUpFriendship]", 0
    assert_select "img[src*=inviteFriend]", 0
    get :show, :id => users(:mike3).id # 发出邀请，等待确认的
    assert_select "#send_friend_invitation_div", 0
    assert_select "img[src*=breakUpFriendship]", 0
    assert_select "img[src*=inviteFriend]", 0
    get :show, :id => users(:saki).id # 朋友
    assert_select "#send_friend_invitation_div", 0
    assert_select "img[src*=breakUpFriendship]"
    assert_select "img[src*=inviteFriend]", 0
    get :show, :id => users(:mike1).id # 其他
    assert_select "#send_friend_invitation_div"
    assert_select "img[src*=breakUpFriendship]", 0
    assert_select "img[src*=inviteFriend]"
  end
  
  def test_blog_uri
    assert_get_uri "sakinijino.blogbus.com"
    assert_get_uri "www.google.com/search?hl=en&q=ruby+url+regexp"
    assert_get_uri "www.google.com/reader/view/#stream/feed%2Fhttp%3A%2F%2Fcn.engadget.com%2Frss.xml"
    assert_get_uri "www.zhuaxia.com/index.php#showCh(18570,10,0,-1,1,1)"
  end
  
  private
    def assert_get_uri(uri)
      u = users(:saki)
      u.blog = uri
      u.save!
      get :show, :id => u.id
      assert_select "a[href=#{u.full_blog_uri}]"
    end
end

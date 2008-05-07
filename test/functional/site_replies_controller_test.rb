require File.dirname(__FILE__) + '/../test_helper'

class SiteRepliesControllerTest < ActionController::TestCase
  def test_should_create_reply
    login_as :quentin
    SitePost.find(site_posts(:saki_1).id).site_replies(:refresh).size
    assert_difference('SitePost.find(site_posts(:saki_1).id).site_replies.size') do
      post :create, :site_post_id => site_posts(:saki_1).id, :reply => {:content=>"1234567890"}
    end
    assert_redirected_to site_post_path(site_posts(:saki_1))
  end
  
  def test_create_reply_error
    login_as :quentin
    SitePost.find(site_posts(:saki_1).id).site_replies(:refresh).size
    assert_no_difference('SitePost.find(site_posts(:saki_1).id).site_replies.size') do
      post :create, :site_post_id => site_posts(:saki_1).id, :reply => {:content=>""}
      assert_equal 2, assigns(:replies).length
    end
    assert_template "site_posts/show"
  end
  
  def test_create_reply_no_auth
    SitePost.find(site_posts(:saki_1).id).site_replies(:refresh).size
    assert_difference('SitePost.find(site_posts(:saki_1).id).site_replies.size') do
      post :create, :site_post_id => site_posts(:saki_1).id, :reply => {:content=>"1234566", :email=>'123@456.com'}
    end
    assert_redirected_to site_post_path(site_posts(:saki_1))
  end

  def test_should_destroy_reply
    login_as :saki
    SitePost.find(site_posts(:saki_1).id).site_replies(:refresh).size
    assert_difference('SitePost.find(site_posts(:saki_1).id).site_replies.size', -1) do
      delete :destroy, :id => site_replies(:saki_1_reply).id
    end
    assert_redirected_to site_post_path(site_posts(:saki_1))
  end
  
  def test_should_destroy_reply_by_admin
    login_as :mike2
    SitePost.find(site_posts(:saki_1).id).site_replies(:refresh).size
    assert_difference('SitePost.find(site_posts(:saki_1).id).site_replies.size', -1) do
      delete :destroy, :id => site_replies(:saki_1_reply).id
    end
    assert_redirected_to site_post_path(site_posts(:saki_1))
  end
  
  def test_should_destroy_reply_no_auth
    login_as :aaron
    SitePost.find(site_posts(:saki_1).id).site_replies(:refresh).size
    assert_no_difference('SitePost.find(site_posts(:saki_1).id).site_replies.size') do
      delete :destroy, :id => site_replies(:saki_1_reply).id
    end
    assert_fake_redirected
  end
end

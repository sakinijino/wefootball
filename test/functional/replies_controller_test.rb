require File.dirname(__FILE__) + '/../test_helper'

class RepliesControllerTest < ActionController::TestCase
  def test_should_create_reply
    login_as :quentin
    Post.find(posts(:saki_1).id).replies(:refresh).size
    assert_difference('Post.find(posts(:saki_1).id).replies.size') do
      post :create, :post_id => posts(:saki_1).id, :reply => {:content=>"1234567890"}
    end
    assert_redirected_to post_path(posts(:saki_1))
  end
  
  def test_create_reply_error
    login_as :quentin
    Post.find(posts(:saki_1).id).replies(:refresh).size
    assert_no_difference('Post.find(posts(:saki_1).id).replies.size') do
      post :create, :post_id => posts(:saki_1).id, :reply => {:content=>""}
      assert_equal 1, assigns(:post).replies.length
    end
    assert_template "posts/show"
  end
  
  def test_create_reply_no_auth
    login_as :aaron
    Post.find(posts(:saki_1).id).replies(:refresh).size
    assert_no_difference('Post.find(posts(:saki_1).id).replies.size') do
      post :create, :post_id => posts(:saki_1).id, :reply => {:content=>""}
    end
    assert_fake_redirected
  end

  def test_should_destroy_reply
    login_as :quentin
    Post.find(posts(:saki_1).id).replies(:refresh).size
    assert_difference('Post.find(posts(:saki_1).id).replies.size', -1) do
      delete :destroy, :id => replies(:quentin_1_reply).id
    end
    assert_redirected_to post_path(posts(:saki_1))
  end
  
  def test_should_destroy_reply_no_auth
    login_as :aaron
    Post.find(posts(:saki_1).id).replies(:refresh).size
    assert_no_difference('Post.find(posts(:saki_1).id).replies.size') do
      delete :destroy, :id => replies(:quentin_1_reply).id
    end
    assert_fake_redirected
  end
end

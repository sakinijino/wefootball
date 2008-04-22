require File.dirname(__FILE__) + '/../test_helper'

class SitePostsControllerTest < ActionController::TestCase
  def test_should__index
    get :index
    assert_response :success
    assert_equal 2, assigns(:site_posts).length
  end
  
  def test_get_show_logged_in
    login_as :quentin
    get :show, :id => site_posts(:saki_1).id
    assert_select "#reply_email", 0
  end

  def test_get_show_do_not_login
    get :show, :id => site_posts(:saki_1).id
    assert_select "#reply_email"
  end
  
  def test_get_new_logged_in
    login_as :aaron
    get :new
    assert_select "#site_post_email", 0
  end
  
  def test_get_new_do_not_login
    get :new
    assert_select "#site_post_email"
  end

  def test_should_create_post
    login_as :quentin
    assert_difference('SitePost.count') do
    assert_difference('users(:quentin).site_posts.reload.length') do
      post :create, :site_post => { :title => 'Test', :content => '123456'}
    end
    end
    assert_equal users(:quentin).id, assigns(:site_post).user_id
    assert_redirected_to site_post_path(assigns(:site_post))
  end
  
  def test_should_create_post_do_not_login
    assert_difference('SitePost.count') do
      post :create, :site_post => { :title => 'Test', :content => '123456'}
    end
    assert_nil assigns(:site_post).user_id
    assert_redirected_to site_post_path(assigns(:site_post))
  end

  def test_should_destroy_post
    login_as :saki
    assert_difference('SitePost.count', -1) do
      delete :destroy, :id => site_posts(:saki_1).id
    end
    assert_redirected_to site_posts_path
  end
  
  def test_destroy_post_unauth
    login_as :quentin
    assert_no_difference('SitePost.count') do
      delete :destroy, :id => site_posts(:saki_1).id
    end
    assert_redirected_to '/'
  end
end

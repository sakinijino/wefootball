require File.dirname(__FILE__) + '/../test_helper'

class PostsControllerTest < ActionController::TestCase
  def test_should_get_team_index
    get :index, :team_id => 1
    assert_response :success
    assert_equal 2, assigns(:posts).length
  end
  
  def test_should_get_training_index
    get :index, :training_id => 1
    assert_response :success
    assert_equal 2, assigns(:posts).length
  end
  
  def test_should_get_team_index_private
    login_as :saki
    get :index, :team_id => 1
    assert_response :success
    assert_equal 4, assigns(:posts).length
  end
  
  def test_should_get_training_index_private
    login_as :saki
    get :index, :training_id => 1
    assert_response :success
    assert_equal 3, assigns(:posts).length
  end
  
  def test_get_show_noauth
    login_as :aaron
    get :show, :id => posts(:saki_3).id
    assert_redirected_to '/'
  end
  
  def test_get_new_noauth
    login_as :aaron
    get :new, :team => 1
    assert_redirected_to '/'
    get :new, :training => 1
    assert_redirected_to '/'
  end
  
  def test_get_edit_noauth
    login_as :quentin
    get :edit, :id=> posts(:saki_1)
    assert_redirected_to '/'
  end
  
  def test_should_create_post
    login_as :quentin
    assert_difference('Post.count') do
    assert_difference('Training.find(trainings(:training1).id).team.posts.length') do
    assert_difference('Training.find(trainings(:training1).id).posts.length') do
      post :create, :training_id=>trainings(:training1).id, :post => { :title => 'Test', :content => '123456'}
    end
    end
    end
    assert_equal users(:quentin).id, assigns(:post).user_id
    assert_redirected_to post_path(assigns(:post))
    assert_difference('Post.count') do
    assert_difference('Team.find(teams(:inter).id).posts.length') do
      post :create, :team_id=>teams(:inter).id, :post => { :title => 'Test', :content => '123456'}
    end
    end
    assert_equal users(:quentin).id, assigns(:post).user_id
    assert_redirected_to post_path(assigns(:post))
  end

  def test_should_update_post
    login_as :saki
    put :update, :id => posts(:saki_1).id, :post => { :content => '123456' }
    assert_equal '123456', assigns(:post).content
    assert_redirected_to post_path(assigns(:post))
  end

  def test_should_destroy_post
    login_as :quentin
    assert_difference('Post.count', -1) do
      delete :destroy, :id => posts(:saki_1).id
    end
    assert_redirected_to team_posts_url(posts(:saki_1).team_id)
  end
end

require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      assert 'sakinijino@gmail.com', assigns["user"].login
      assert_redirected_to "/"
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_template "new"
    end
  end
  
  def test_login_should_be_an_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => 'saki')
      assert assigns(:user).errors.on(:login)
      assert_template "new"
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_template "new"
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_template "new"
    end
  end  
  
  def test_show_user
    login_as :saki
    get :show, :id=>users(:saki).id
    assert_template "show"
    get :show, :id=>users(:mike1).id
    assert_select 'a', '加为好友'
    get :show, :id=>users(:mike2).id
    assert_select 'a', '不和他玩'
    assert_select 'a', '发信'
  end
  
  def test_update_success
    login_as :quentin
    put :update, :id=>1, :user=>{:summary=>'Yada!!', :is_playable=>"1"}, :positions=>['SS', 'DM']
    assert_redirected_to edit_user_url(assigns(:user))
    assert_equal 'Yada!!', assigns(:user).summary
    assert_equal 2, assigns(:user).positions.length
    assert_equal 'SS', assigns(:user).premier_position
    put :update, :id=>1, :user=>{:is_playable=>"1"}
    assert_redirected_to edit_user_url(assigns(:user))
    assert_equal 1, assigns(:user).positions.length
    assert_equal 'GK', assigns(:user).premier_position
    put :update, :id=>1, :user=>{:is_playable=>"0"}, :positions=>['SW', 'LB']
    assert_redirected_to edit_user_url(assigns(:user))
    assert_equal 0, assigns(:user).positions.length
  end
  
  def test_update_error
    login_as :quentin
    put :update, :id=>1, :user=>{:password=>'111111', :password_confirmation => '123'}
    assert assigns(:user).errors.on(:password)
    assert_template "edit"
  end
  
  def test_should_login_before_update_user
    put :update, :id=>1
    assert_redirected_to new_session_path
  end
  
  def test_should_not_update_other_user
    login_as :quentin
    put :update, :id=>2, :user=>{:login=>'saki@gmail.com'}
    assert_redirected_to "/"
  end

  protected
    def create_user(options = {})
      post :create, :user => { :login => 'sakinijino@gmail.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end

require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end
class SessionsController; def new() render :text=>'new' end; end

class SessionsControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @request.env["HTTP_ACCEPT"] = "application/xml"
    @response   = ActionController::TestResponse.new
  end

  def test_should_login
    post :create, :login => 'sakinijino0725@163.com', :password => 'test'
    assert session[:user_id]
    assert_select 'login', 'sakinijino0725@163.com'
    assert_select 'weight', '62.0'
    assert_select 'height', '172.0'
    assert_select 'nickname', 'saki'
    assert_select 'fitfoot', 'R'
    assert_select 'birthday', '1984-03-10'
    assert_select 'summary', 'weFootball!'
    assert_select 'position', 'CB'
    assert_select 'position', :count=>3
    assert_nil find_tag(:tag=>'password')
  end

  def test_should_fail_login_and_not_redirect
    post :create, :login => 'quire@example.com', :password => 'bad password'
    assert_nil session[:user_id]
    assert_response 401
  end

  def test_should_logout
    login_as :quentin
    delete :destroy
    assert_nil session[:user_id]
    assert_response 200
  end

  def test_should_remember_me
    post :create, :login => 'quire@example.com', :password => 'test', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    post :create, :login => 'quire@example.com', :password => 'test', :remember_me => "0"
    assert_nil @response.cookies["auth_token"]
  end
  
  def test_should_delete_token_on_logout
    login_as :quentin
    get :destroy
    assert_equal @response.cookies["auth_token"], []
  end

  def test_should_login_with_cookie
    users(:quentin).remember_me
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    assert @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    users(:quentin).remember_me
    users(:quentin).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    users(:quentin).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    assert !@controller.send(:logged_in?)
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
end

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
    @request.env["HTTP_ACCEPT"] = "application/xml"
    @response   = ActionController::TestResponse.new
  end

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      assert_select 'login', 'sakinijino@gmail.com'
      assert_nil find_tag(:tag=>'password')
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :unprocessable_entity
      tag = find_tag :tag=>"error", :attributes=>{:field=>"login"}
      assert_not_nil tag
    end
  end
  
  def test_login_should_be_an_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => 'saki')
      assert assigns(:user).errors.on(:login)
      assert_response :unprocessable_entity
      tag = find_tag :tag=>"error", :attributes=>{:field=>"login"}
      assert_not_nil tag
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :unprocessable_entity
      tag = find_tag :tag=>"error", :attributes=>{:field=>"password"}
      assert_not_nil tag
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :unprocessable_entity
      tag = find_tag :tag=>"error", :attributes=>{:field=>"password_confirmation"}
      assert_not_nil tag
    end
  end  

  protected
    def create_user(options = {})
      post :create, :user => { :login => 'sakinijino@gmail.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end

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
      assert_select 'nickname', 'sakinijino'
      assert_nil find_tag(:tag=>'password')
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response 200
      tag = find_tag :tag=>"error", :attributes=>{:field=>"login"}
      assert_not_nil tag
    end
  end
  
  def test_login_should_be_an_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => 'saki')
      assert assigns(:user).errors.on(:login)
      assert_response 200
      tag = find_tag :tag=>"error", :attributes=>{:field=>"login"}
      assert_not_nil tag
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response 200
      tag = find_tag :tag=>"error", :attributes=>{:field=>"password"}
      assert_not_nil tag
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response 200
      tag = find_tag :tag=>"error", :attributes=>{:field=>"password_confirmation"}
      assert_not_nil tag
    end
  end  
  
  def test_show_user
    login_as :saki
    get :show, :id=>users(:saki).id
    assert_select 'login', 'sakinijino0725@163.com'
    assert_select 'birthday', '03/10/1984'
    assert_select 'is_my_friend', 'false'
    get :show, :id=>users(:mike1).id
    assert_select 'is_my_friend', 'false'
    get :show, :id=>users(:mike2).id
    assert_select 'is_my_friend', 'true'
    get :show, :id=>-1
    assert_response 404
  end
  
  def test_update_success
    login_as :quentin
    put :update, :id=>1, :user=>{:summary=>'Yada!!'}, :positions=>['SW', 'LB']
    assert_response 200
    assert_select 'login', 'quire@example.com'
    assert_select 'summary', 'Yada!!'
    assert_select 'position', 'SW'
    assert_select 'position', :count=>2
  end
  
  def test_update_error
    login_as :quentin
    put :update, :id=>1, :user=>{:password=>'111111', :password_confirmation => '123'}
    assert_response 200
    tag = find_tag :tag=>"error", :attributes=>{:field=>"password"}
    assert_not_nil tag
  end
  
  def test_should_login_before_update_user
    put :update, :id=>1
    assert_response 401
  end
  
  def test_should_not_update_other_user
    login_as :quentin
    put :update, :id=>2, :user=>{:login=>'saki@gmail.com'}
    assert_response 401
  end
  
  def test_should_not_update_login_name
    login_as :quentin
    put :update, :id=>1, :user=>{:login=>'saki@gmail.com'}
    assert_select 'login', 'quire@example.com'
  end
  
  def test_should_get_team_users_index
    login_as :saki
    get :index, :team_id => teams(:inter).id
    assert_response 200
    assert_select "user", :count=>2
  end
  
  def test_should_get_training_users_index
    login_as :saki
    get :index, :training_id => trainings(:training1).id
    assert_response 200
    assert_select "user", 1
    assert_select "users>user>nickname", 'saki'
  end
  
  def test_search
    create_user({:login => 'sakinijinoo@gmail.com', :nickname=>'AiHaibara'})
    get :search, :query => "AiHaibara"
    assert_response 200
    assert_select "user", 1
    create_user({:login => 'sakinijinoo0725@gmail.com', :nickname=>'AiHaibara'})
    get :search, :query => "gmail"
    assert_response 200
    assert_select "user", 2
  end

  protected
    def create_user(options = {})
      post :create, :user => { :login => 'sakinijino@gmail.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end

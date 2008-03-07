require File.dirname(__FILE__) + '/../test_helper'

class ApplicationController < ActionController::Base
  def current_user_is_football_ground_editor?
    current_user.login == "sakinijino0725@163.com"
  end
end

class FootballGroundsControllerTest < ActionController::TestCase
  
  def test_should_get_index_unauthorize
    login_as :saki
    get :index_unauthorize
    assert_template "index"
    assert_equal 2, assigns(:football_grounds).length
  end
  
  def test_get_index_unauthorize_with_not_editor
    login_as :mike1
    get :index_unauthorize
    assert_redirected_to '/'
  end

  def test_should_create_football_ground
    login_as :mike1
    assert_difference('FootballGround.count(:conditions => ["status = 0"])') do
      post :create, :football_ground => {:name => 'Test' }, :back_uri => "/public"
    end
    assert_redirected_to "/public"
  end

  def test_get_edit_with_not_editor
    login_as :mike1
    get :edit, :id => football_grounds(:yiti).id
    assert_redirected_to '/'
  end

  def test_should_update_football_ground
    login_as :saki
    put :update, :id => football_grounds(:daishenhe1).id, :football_ground => {:name => 'Modify', :status => 1 }
    assert_equal "Modify", assigns(:football_ground).name
    assert_equal 1, assigns(:football_ground).status
    assert_redirected_to football_ground_path(assigns(:football_ground))
    put :update, :id => football_grounds(:yiti).id, :football_ground => {:name => 'Modify', :status => 0 }
    assert_equal "Modify", assigns(:football_ground).name
    assert_equal 1, assigns(:football_ground).status
    assert_redirected_to football_ground_path(assigns(:football_ground))
  end
  
  def test_update_with_not_editor
    login_as :mike1
    n = football_grounds(:daishenhe1).name
    put :update, :id => football_grounds(:daishenhe1).id, :football_ground => {:name => 'Modify', :status => 1 }
    assert_equal n, assigns(:football_ground).name
    assert_redirected_to '/'
  end

  def test_should_destroy_football_ground
    login_as :saki
    assert_difference('FootballGround.count', -1) do
      delete :destroy, :id => football_grounds(:daishenhe1).id
    end
    assert_redirected_to :action => 'index_unauthorize'
    assert_no_difference('FootballGround.count') do
      delete :destroy, :id => football_grounds(:yiti).id
    end
    assert_redirected_to '/'
  end
  
  def test_update_with_not_editor
    login_as :mike1
    assert_no_difference('FootballGround.count') do
      delete :destroy, :id => football_grounds(:daishenhe1).id
    end
    assert_redirected_to '/'
  end
end

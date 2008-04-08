require File.dirname(__FILE__) + '/../test_helper'

class PlaysControllerTest < ActionController::TestCase

  
  def test_unlogin
    get :new
    assert_redirected_to new_session_path    
    post :create
    assert_redirected_to new_session_path     
  end
  
    
  def test_create
    login_as :mike1

    assert_difference('Play.count',1) do
      post :create, :play=>{:football_ground_id=>football_grounds(:yiti).id}
    end
    assert_equal assigns(:play).play_joins.map{|item| item.user},[users(:mike1)]
    assert_redirected_to play_path(assigns(:play))

    assert_no_difference('Play.count') do
      post :create, :play=>{}
    end
    assert_template 'new'     
    #测试一下创建play后创建join
  end
  
end

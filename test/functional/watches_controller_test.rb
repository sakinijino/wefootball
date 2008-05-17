require File.dirname(__FILE__) + '/../test_helper'

class WatchesControllerTest < ActionController::TestCase
  def test_unlogin
    get :new
    assert_redirected_to new_session_path          
    post :create
    assert_redirected_to new_session_path
    get :edit
    assert_redirected_to new_session_path    
    put :update
    assert_redirected_to new_session_path    
    delete :destroy
    assert_redirected_to new_session_path     
  end


  def test_should_not_create_watch
    login_as :saki
    assert_no_difference('Watch.count') do
      #没有填时间地点
      post :create, :watch => {:official_match_id=>official_matches(:one).id }
      assert_template 'new'
    end
    assert_no_difference('Watch.count') do
      #地点过长
      post :create, :watch => {:official_match_id=>official_matches(:one).id,
                                :start_time => Time.now,
                                :location => 's'*101}
      assert_template 'new'
    end    
  end
  
  def test_should_create_watch
    login_as :saki    
    assert_difference('Watch.count', 1) do
      assert_difference('WatchJoin.count', 1) do      
        post :create, :watch => {:official_match_id=>official_matches(:one).id,
                                  :start_time => Time.now,
                                  :location => 's'}
        assert_redirected_to watch_path(assigns(:watch))
        assert_equal users(:saki), assigns(:watch).admin
        assert_equal official_matches(:one), assigns(:watch).official_match
        assert_equal users(:saki), WatchJoin.find_by_watch_id(assigns(:watch)).user        
      end
    end    
  end  


  def test_edit
    login_as :saki
    get :edit, :id => watches(:one).id
    assert_response :success    
    get :edit, :id => watches(:two).id
    assert_response 403
  end

  def test_update
    login_as :saki

    put :update, :id => watches(:two).id
    assert_response 403
    
    assert_equal "MyString", watches(:one).location
    assert_equal "2008-05-13", watches(:one).start_time.strftime("%Y-%m-%d")
    assert_equal "MyText", watches(:one).description
    assert_equal users(:saki), watches(:one).admin
    assert_equal official_matches(:one), watches(:one).official_match 
    put :update, :id => watches(:one).id, :watch => {:location=>'test1',
                                                       :start_time=>"2008-05-14",
                                                       :description=>"test2",
                                                       :user_id=>users(:mike1).id,
                                                       :official_match_id=>official_matches(:one).id+1
                                                      }
    watches(:one).reload
    assert_equal "test1", watches(:one).location
    assert_equal "2008-05-14", watches(:one).start_time.strftime("%Y-%m-%d")
    assert_equal "test2", watches(:one).description
    assert_equal users(:saki), watches(:one).admin
    assert_equal official_matches(:one), watches(:one).official_match     
    assert_redirected_to watch_path(assigns(:watch))
  end

  def test_destroy_watch
    login_as :saki    
    assert_difference('Watch.count', -1) do
      delete :destroy, :id => watches(:one).id
    end
    assert_redirected_to official_match_path(assigns(:watch).official_match_id)    
  end  

end

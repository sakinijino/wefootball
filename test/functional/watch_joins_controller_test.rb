require File.dirname(__FILE__) + '/../test_helper'

class WatchJoinsControllerTest < ActionController::TestCase

  def test_unlogin
    post :create
    assert_redirected_to new_session_path    
    get :select_new_admin
    assert_redirected_to new_session_path     
    delete :destroy_admin
    assert_redirected_to new_session_path    
    delete :destroy
    assert_redirected_to new_session_path       
  end  
  
  def test_should_create
    login_as :mike1
    
    assert_equal 0, official_matches(:one).watch_count
    assert_equal 0, official_matches(:one).watch_join_count    
    w = Watch.new(:start_time=>Time.now, :location=>'yiti')
    w.official_match = official_matches(:one)
    w.save!
    official_matches(:one).reload
    assert_equal 1, official_matches(:one).watch_count
    assert_equal 0, official_matches(:one).watch_join_count      
    assert_difference('WatchJoin.count',1) do
      post :create, :watch_id=>w.id
    end
    assert_equal [w], users(:mike1).watch_joins.map{|item| item.watch}
    official_matches(:one).reload
    w.reload
    assert_equal 1, w.watch_join_count     
    assert_equal 1, official_matches(:one).watch_count
    assert_equal 1, official_matches(:one).watch_join_count   
    assert_redirected_to watch_path(assigns(:watch)) 
  end
  
  def test_should_not_create
    login_as :mike1
    
    w = Watch.new(:start_time=>Time.now, :location=>'yiti')
    w.official_match = official_matches(:one)
    w.save!
    post :create, :watch_id=>w.id
    assert_equal [w], users(:mike1).watch_joins.map{|item| item.watch}
    post :create, :watch_id=>w.id #已参加后就不能重复参加
    assert_fake_redirected    
  end
  
  def test_should_destroy_a_common_user_with_more_than_one_users  
    login_as :quentin    
    
    w = watches(:one)
    official_matches(:one).watch_join_count = 1
    official_matches(:one).save!
    w.watch_join_count = 1
    w.save!
    
    #在夹具中，共有三个用户参加watches(:one)
    assert_equal 3, WatchJoin.count
    assert_difference('WatchJoin.count',-1) do
      delete :destroy, :watch_id=>w.id
    end
    
    official_matches(:one).reload
    w.reload
    assert_equal 0, official_matches(:one).watch_join_count
    assert_equal 0, w.watch_join_count    
  end
  
  def test_should_destroy_with_only_one_user
    login_as :mike1
    
    w = Watch.new(:start_time=>Time.now, :location=>'yiti')
    w.official_match = official_matches(:one)
    w.admin = users(:mike1)
    w.save!
    post :create, :watch_id=>w.id
    assert_equal [users(:mike1)], w.watch_joins.map{|item| item.user}
    assert_equal 1, WatchJoinBroadcast.find_all_by_activity_id(w.id).size
    
    assert_difference('WatchJoin.count',-1) do
      delete :destroy, :watch_id=>w.id
    end
    assert_equal [], WatchJoin.find_all_by_watch_id(w.id)
    #级联删除
    assert_equal [], Watch.find_all_by_id(w.id)
    #广播的级联删除
    assert_equal 0, WatchJoinBroadcast.find_all_by_activity_id(w.id).size
  end

  def test_should_destroy_admin
    login_as :saki   
    
    w = watches(:one)
    assert_equal users(:saki), w.admin
    
    wj = WatchJoin.find_by_user_id(users(:aaron))
    delete :destroy_admin, :watch_join_id=>wj.id
    w.reload
    assert_equal users(:aaron), w.admin
    assert_equal nil, WatchJoin.find_by_user_id(users(:saki))
    assert_redirected_to watch_path(w)
  end  
end

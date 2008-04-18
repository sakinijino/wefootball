require File.dirname(__FILE__) + '/../test_helper'

class PlayJoinsControllerTest < ActionController::TestCase

  def test_unlogin
    post :create
    assert_redirected_to new_session_path    
    delete :destroy
    assert_redirected_to new_session_path     
  end  
  
  def test_should_create
    login_as :mike1
    
    p = Play.create!(:football_ground_id=>football_grounds(:yiti).id)
    assert_difference('PlayJoin.count',1) do
      post :create, :play_id=>p.id
    end
    assert_equal [p], users(:mike1).play_joins.map{|item| item.play}
    assert_redirected_to play_path(assigns(:play)) 
  end
  
#  def test_should_not_create
#    login_as :mike1
#    
#    p = Play.new(:football_ground_id=>football_grounds(:yiti).id)
#    p.start_time = 1.hour.ago #比赛已经开始后就不能再参加
#    p.save_without_validation!
#    assert_no_difference('PlayJoin.count') do
#      post :create, :play_id=>p.id
#    end
#    assert_redirected_to '/'
#    
#    p.start_time = 1.hour.since
#    p.save!
#    post :create, :play_id=>p.id
#    assert_equal [p], users(:mike1).play_joins.map{|item| item.play}
#    post :create, :play_id=>p.id #已参加后就不能重复参加
#    assert_redirected_to '/'    
#  end
  
  def test_should_destroy
    login_as :mike1
    
    p = Play.create!(:football_ground_id=>football_grounds(:yiti).id)
    post :create, :play_id=>p.id
    assert_equal [p], users(:mike1).play_joins.map{|item| item.play}#mike1已参加该play
    assert_difference('PlayJoin.count',-1) do
      delete :destroy, :play_id=>p.id
    end
    assert_equal [], users(:mike1).play_joins.reload
    assert_equal nil, Play.find_by_id(p.id)
    assert_redirected_to user_view_path(users(:mike1))     
  end
  
  def test_should_not_destroy
    login_as :mike1
    
    p = Play.new(:football_ground_id=>football_grounds(:yiti).id)
    p.start_time = 1.hour.ago #比赛已经开始后就不能再退出
    p.save_without_validation!
    assert_no_difference('PlayJoin.count') do
      post :destroy, :play_id=>p.id
    end
    assert_redirected_to '/'
    
    p.start_time = 1.hour.since
    p.save!
    post :destroy, :play_id=>p.id #未参加时不能退出
    assert_redirected_to '/'    
  end
  
end

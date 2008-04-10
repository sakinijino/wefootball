require File.dirname(__FILE__) + '/../test_helper'

class MatchJoinsControllerTest < ActionController::TestCase
  
  self.use_transactional_fixtures = false
  
  def test_should_create_match_join
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    login_as :quentin
    assert_difference('MatchJoin.find_all_by_user_id_and_team_id_and_match_id(users(:quentin), teams(:inter), matches(:one)).size') do
    assert_difference('MatchJoin.count') do
      post :create, :match_id=>matches(:one).id, :team_id=>teams(:inter)
      assert_redirected_to match_path(matches(:one).id)
    end
    end
  end
  
  def test_should_create_match_join_with_an_undetermined_join
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    tj = MatchJoin.new
    tj.user = users(:quentin)
    tj.match = matches(:one)
    tj.team = teams(:inter)
    tj.status = MatchJoin::UNDETERMINED
    tj.save!
    
    login_as :quentin
    assert_no_difference('MatchJoin.count') do
      post :create, :match_id=>matches(:one).id, :team_id=>teams(:inter)
      assert_redirected_to match_path(assigns(:match).id)
      assert_equal MatchJoin::JOIN, tj.reload.status
    end
  end
  
  def test_should_not_join_when_match_is_closed
    matches(:one).start_time = 8.days.ago.ago(7200)
    matches(:one).end_time = 8.days.ago.ago(3600)
    matches(:one).save!
    login_as :quentin
    assert_no_difference('MatchJoin.count') do
      post :create, :match_id=>matches(:one).id, :team_id=>teams(:inter)
      assert_redirected_to '/'
    end
  end
  
  def test_should_not_join_when_is_not_a_member_of_team
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    login_as :aaron
    assert_no_difference('MatchJoin.count') do
      post :create, :match_id=>matches(:one).id, :team_id=>teams(:inter)
      assert_redirected_to '/'
    end
  end
  
  def test_should_not_join_twice
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    tj = MatchJoin.new
    tj.user = users(:saki)
    tj.match = matches(:one)
    tj.team = teams(:inter)
    tj.status = MatchJoin::JOIN
    tj.save!
    
    login_as :saki
    assert_no_difference('MatchJoin.count') do
      post :create, :match_id=>matches(:one).id, :team_id=>teams(:inter)
      assert_redirected_to match_path(assigns(:match).id)
    end
  end

  def test_should_destroy_match_join
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    tj = MatchJoin.new
    tj.user = users(:saki)
    tj.match = matches(:one)
    tj.team = teams(:inter)
    tj.status = MatchJoin::JOIN
    tj.save!
    
    login_as :saki
    assert_difference('MatchJoin.count', -1) do
      delete :destroy, :id => tj.id
      assert_redirected_to match_path(matches(:one).id)
    end
  end
  
  def test_should_destroy_match_join_with_an_undetermined_join
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    tj = MatchJoin.new
    tj.user = users(:quentin)
    tj.match = matches(:one)
    tj.team = teams(:inter)
    tj.status = MatchJoin::UNDETERMINED
    tj.save!
    
    login_as :quentin
    assert_difference('MatchJoin.count', -1) do
      delete :destroy, :id => tj.id
      assert_redirected_to match_path(assigns(:match_join).match_id)
    end
  end
  
  def test_should_not_destroy_match_join_when_it_started
    matches(:one).start_time = Time.now.ago(1800)
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    tj = MatchJoin.new
    tj.user = users(:saki)
    tj.match = matches(:one)
    tj.team = teams(:inter)
    tj.status = MatchJoin::JOIN
    tj.save!
    
    login_as :saki
    assert_no_difference('MatchJoin.count', -1) do
      delete :destroy, :id => tj.id
      assert_redirected_to '/'
    end
  end
  
  def test_should_not_destroy_match_join_of_other_user
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    tj = MatchJoin.new
    tj.user = users(:saki)
    tj.match = matches(:one)
    tj.team = teams(:inter)
    tj.status = MatchJoin::JOIN
    tj.save!
    
    login_as :quentin
    assert_no_difference('MatchJoin.count') do
      delete :destroy, :id => tj.id
      assert_redirected_to '/'
    end
  end
  
  def test_update_formation
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    
    MatchJoin.destroy_all
    ut = MatchJoin.new
    ut.user = users(:saki)
    ut.team = teams(:inter)
    ut.match = matches(:one)
    ut.save!
    login_as :saki
    put :update_formation, :match_id=> matches(:one), :team_id=>teams(:inter).id, :formation => {'3'=>ut.id}
    assert_redirected_to match_path(matches(:one))
    assert_equal 3, ut.reload.position
    
    users(:mike1).update_attributes!(:is_player => true, :fitfoot => 'R', :premier_position=>1)
    tmp = UserTeam.new
    tmp.user = users(:mike1)
    tmp.team = teams(:inter)
    tmp.is_player = true
    tmp.save!
    ut2 = MatchJoin.new
    ut2.user = users(:mike1)
    ut2.team = teams(:inter)
    ut2.match = matches(:one)
    ut2.save!
    put :update_formation, :match_id=> matches(:one), :team_id=>teams(:inter).id, :formation => {'3'=>ut2.id}
    assert_redirected_to match_path(matches(:one))
    assert_nil ut.reload.position
    assert_equal 3, ut2.reload.position
    
    put :update_formation, :match_id=> matches(:one), :team_id=>teams(:inter).id, :formation => {'2'=>ut2.id, '20'=>ut.id}
    assert_redirected_to match_path(matches(:one))
    assert_equal 20, ut.reload.position
    assert_equal 2, ut2.reload.position
    
    put :update_formation, :match_id=> matches(:one), :team_id=>teams(:inter).id, :formation => {'2'=>ut2.id, '27'=>ut.id}
    assert_redirected_to match_path(matches(:one))
    assert_nil ut.reload.position
    assert_equal 2, ut2.reload.position
  end
  
  def test_update_formation_unauth
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    
    ut = MatchJoin.new
    ut.user = users(:saki)
    ut.team = teams(:inter)
    ut.match = matches(:one)
    ut.save!
    login_as :saki
    
    login_as :mike2
    put :update_formation, :match_id=> matches(:one), :team_id=>teams(:inter).id, :formation => {'3'=>ut.id}
    assert_redirected_to '/'
  end
  
  def test_update_formation_with_a_user_team_from_match_join_of_other_match
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    
    t1 = teams(:inter)
    t2 = teams(:milan)
    MatchJoin.destroy_all
    match1 = Match.new   
    match1.host_team_id = t1.id
    match1.guest_team_id = t2.id
    match1.start_time = Time.now.tomorrow
    match1.half_match_length = 25
    match1.rest_length = 10
    match1.location = "一体"
    match1.save!
    MatchJoin.create_joins(match1)   
    mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(users(:saki).id,t1.id,match1.id)
    assert_not_nil mj1
    mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(users(:quentin).id,t1.id,match1.id)
    assert_not_nil mj2
    
    ut = MatchJoin.new
    ut.user = users(:saki)
    ut.team = teams(:inter)
    ut.match = matches(:one)
    ut.position =11
    ut.save!
    assert_equal 11, ut.reload.position
    
    login_as :saki
    put :update_formation, :match_id=> matches(:one).id, :team_id=>teams(:inter).id, :formation => {'13'=>mj1.id, '16'=>mj2.id}
    assert_nil mj1.reload.position
    assert_nil mj2.reload.position
    assert_equal 11, ut.reload.position
    assert_redirected_to '/'
  end
  
  def test_update_formation_with_a_user_team_from_match_join_of_other_team
    t1 = teams(:inter)
    t2 = teams(:milan)
    MatchJoin.destroy_all
    match1 = Match.new   
    match1.host_team_id = t1.id
    match1.guest_team_id = t2.id
    match1.start_time = Time.now.tomorrow
    match1.half_match_length = 25
    match1.rest_length = 10
    match1.location = "一体"
    match1.save!
    MatchJoin.create_joins(match1)   
    mj1 = MatchJoin.find_by_user_id_and_team_id_and_match_id(users(:saki).id,t1.id,match1.id)
    assert_not_nil mj1
    mj2 = MatchJoin.find_by_user_id_and_team_id_and_match_id(users(:aaron).id,t2.id,match1.id)
    assert_not_nil mj2
    
    ut = MatchJoin.new
    ut.user = users(:saki)
    ut.team = teams(:inter)
    ut.match = match1
    ut.position =11
    ut.save!
    assert_equal 11, ut.reload.position
    
    login_as :saki
    put :update_formation, :match_id=> match1.id, :team_id=>teams(:inter).id, :formation => {'13'=>mj1.id, '16'=>mj2.id}
    assert_nil mj1.reload.position
    assert_nil mj2.reload.position
    assert_equal 11, ut.reload.position
    assert_redirected_to '/'
  end
  
  def test_update_formation_with_too_many_positions
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).size = 5;
    matches(:one).save!
    
    uts = {}
    (0..6).each do |i|
      u = UserTeam.new
      u.user = create_user("mike#{i}@position.com")
      u.team = teams(:inter)
      u.is_player = true
      u.save!
      
      uts[i.to_s] = MatchJoin.new
      uts[i.to_s].user = u.user
      uts[i.to_s].team = teams(:inter)
      uts[i.to_s].match = matches(:one)
      uts[i.to_s].save!
    end    
    ut = MatchJoin.new
    ut.user = users(:saki)
    ut.team = teams(:inter)
    ut.match = matches(:one)
    ut.position =11
    ut.save!
    assert_equal 11, ut.reload.position
    
    login_as :saki
    put :update_formation, :match_id=> matches(:one), :team_id=>teams(:inter).id, 
      :formation => uts
    assert_equal 11, ut.reload.position
    assert_redirected_to '/'
  end
  
protected
  def create_user(login)
    u = User.new :password => 'quire', :password_confirmation => 'quire'
    u.login = login
    u.is_playable = true
    u.fitfoot = 'R'
    u.premier_position = 0
    u.save!
    u
  end
end

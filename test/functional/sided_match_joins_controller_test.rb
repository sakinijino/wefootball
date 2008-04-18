require File.dirname(__FILE__) + '/../test_helper'

class SidedMatchJoinsControllerTest < ActionController::TestCase
  
  self.use_transactional_fixtures = false
  
  def test_should_create_match_join
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    login_as :quentin
    assert_difference('SidedMatchJoin.find_all_by_user_id_and_match_id(users(:quentin), sided_matches(:one)).size') do
    assert_difference('SidedMatchJoin.count') do
      post :create, :match_id=>sided_matches(:one).id
      assert_redirected_to sided_match_path(sided_matches(:one).id)
    end
    end
  end
  
  def test_should_create_match_join_with_an_undetermined_join
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    tj = SidedMatchJoin.new
    tj.user = users(:quentin)
    tj.sided_match = sided_matches(:one)
    tj.status = SidedMatchJoin::UNDETERMINED
    tj.save!
    assert !sided_matches(:one).has_joined_member?(users(:quentin))
    
    login_as :quentin
    assert_no_difference('SidedMatchJoin.count') do
      post :create, :match_id=>sided_matches(:one).id
      assert_redirected_to sided_match_path(assigns(:sided_match).id)
      assert_equal SidedMatchJoin::JOIN, tj.reload.status
    end
  end
  
#  def test_should_not_join_when_match_is_finished
#    sided_matches(:one).start_time = 1.days.ago.ago(7200)
#    sided_matches(:one).end_time = 1.days.ago.ago(3600)
#    sided_matches(:one).save!
#    login_as :quentin
#    assert_no_difference('SidedMatchJoin.count') do
#      post :create, :match_id=>sided_matches(:one).id
#      assert_redirected_to '/'
#    end
#  end
  
  def test_should_not_join_when_is_not_a_member_of_team
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    login_as :aaron
    assert_no_difference('SidedMatchJoin.count') do
      post :create, :match_id=>sided_matches(:one).id
      assert_redirected_to '/'
    end
  end
  
  def test_should_not_join_twice
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    tj = SidedMatchJoin.new
    tj.user = users(:saki)
    tj.sided_match = sided_matches(:one)
    tj.status = SidedMatchJoin::JOIN
    tj.save!
    
    login_as :saki
    assert_no_difference('SidedMatchJoin.count') do
      post :create, :match_id=>sided_matches(:one).id
      assert_redirected_to sided_match_path(assigns(:sided_match).id)
    end
  end

  def test_should_destroy_match_join
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    tj = SidedMatchJoin.new
    tj.user = users(:saki)
    tj.sided_match = sided_matches(:one)
    tj.status = SidedMatchJoin::JOIN
    tj.save!
    
    login_as :saki
    assert_difference('SidedMatchJoin.count', -1) do
      delete :destroy, :match_id => sided_matches(:one).id, :id=>0
      assert_redirected_to sided_match_path(sided_matches(:one).id)
    end
  end
  
  def test_should_destroy_match_join_with_an_undetermined_join
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    tj = SidedMatchJoin.new
    tj.user = users(:quentin)
    tj.sided_match = sided_matches(:one)
    tj.status = SidedMatchJoin::UNDETERMINED
    tj.save!
    
    login_as :quentin
    assert_difference('SidedMatchJoin.count', -1) do
      delete :destroy, :match_id => sided_matches(:one).id, :id=>0
      assert_redirected_to sided_match_path(sided_matches(:one).id)
    end
  end
  
#  def test_should_not_destroy_match_join_when_it_started
#    sided_matches(:one).start_time = Time.now.ago(1800)
#    sided_matches(:one).half_match_length = 25
#    sided_matches(:one).rest_length = 10
#    sided_matches(:one).save!
#    tj = SidedMatchJoin.new
#    tj.user = users(:saki)
#    tj.sided_match = sided_matches(:one)
#    tj.status = SidedMatchJoin::JOIN
#    tj.save!
#    
#    login_as :saki
#    assert_no_difference('SidedMatchJoin.count', -1) do
#      delete :destroy, :match_id => sided_matches(:one).id, :id=>0
#      assert_redirected_to '/'
#    end
#  end
  
  def test_update_formation
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    
    SidedMatchJoin.destroy_all
    ut = SidedMatchJoin.new
    ut.user = users(:saki)
    ut.sided_match = sided_matches(:one)
    ut.save!
    login_as :saki
    put :update_formation, :match_id=> sided_matches(:one), :formation => {'3'=>ut.id}
    assert_redirected_to sided_match_path(sided_matches(:one))
    assert_equal 3, ut.reload.position
    
    users(:mike1).update_attributes!(:is_player => true, :fitfoot => 'R', :premier_position=>1)
    tmp = UserTeam.new
    tmp.user = users(:mike1)
    tmp.team = teams(:inter)
    tmp.is_player = true
    tmp.save!
    ut2 = SidedMatchJoin.new
    ut2.user = users(:mike1)
    ut2.sided_match = sided_matches(:one)
    ut2.save!
    put :update_formation, :match_id=> sided_matches(:one), :formation => {'3'=>ut2.id}
    assert_redirected_to sided_match_path(sided_matches(:one))
    assert_nil ut.reload.position
    assert_equal 3, ut2.reload.position
    
    put :update_formation, :match_id=> sided_matches(:one), :formation => {'2'=>ut2.id, '20'=>ut.id}
    assert_redirected_to sided_match_path(sided_matches(:one))
    assert_equal 20, ut.reload.position
    assert_equal 2, ut2.reload.position
    
    put :update_formation, :match_id=> sided_matches(:one), :formation => {'2'=>ut2.id, '27'=>ut.id}
    assert_redirected_to sided_match_path(sided_matches(:one))
    assert_nil ut.reload.position
    assert_equal 2, ut2.reload.position
  end
  
  def test_update_formation_unauth
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    
    ut = SidedMatchJoin.new
    ut.user = users(:saki)
    ut.sided_match = sided_matches(:one)
    ut.save!
    login_as :saki
    
    login_as :mike2
    put :update_formation, :match_id=> sided_matches(:one), :formation => {'3'=>ut.id}
    assert_redirected_to '/'
  end
  
  def test_update_formation_with_a_user_team_from_match_join_of_other_match
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    
    SidedMatchJoin.destroy_all
    match1 = sided_matches(:two)
    SidedMatchJoin.create_joins(match1)   
    mj1 = SidedMatchJoin.find_by_user_id_and_match_id(users(:saki).id,match1.id)
    assert_not_nil mj1
    mj2 = SidedMatchJoin.find_by_user_id_and_match_id(users(:quentin).id,match1.id)
    assert_not_nil mj2
    
    ut = SidedMatchJoin.new
    ut.user = users(:saki)
    ut.sided_match = sided_matches(:one)
    ut.position =11
    ut.save!
    assert_equal 11, ut.reload.position
    
    login_as :saki
    put :update_formation, :match_id=> sided_matches(:one).id, :formation => {'13'=>mj1.id, '16'=>mj2.id}
    assert_nil mj1.reload.position
    assert_nil mj2.reload.position
    assert_equal 11, ut.reload.position
    assert_redirected_to '/'
  end
  
  def test_update_formation_with_too_many_positions
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).size = 5;
    sided_matches(:one).save!
    
    uts = {}
    (0..6).each do |i|
      u = UserTeam.new
      u.user = create_user("mike#{i}@position.com")
      u.team = teams(:inter)
      u.is_player = true
      u.save!
      
      uts[i.to_s] = SidedMatchJoin.new
      uts[i.to_s].user = u.user
      uts[i.to_s].sided_match = sided_matches(:one)
      uts[i.to_s].save!
    end    
    ut = SidedMatchJoin.new
    ut.user = users(:saki)
    ut.sided_match = sided_matches(:one)
    ut.position =11
    ut.save!
    assert_equal 11, ut.reload.position
    
    login_as :saki
    put :update_formation, :match_id=> sided_matches(:one), 
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

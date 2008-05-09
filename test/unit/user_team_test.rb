require File.dirname(__FILE__) + '/../test_helper'

class UserTeamTest < ActiveSupport::TestCase
  def test_set_is_player
    ut = UserTeam.new
    assert !ut.is_player 
    ut.is_player = true
    ut.is_player = false
    assert !ut.is_player_updated_to_false
    
    ut = user_teams(:saki_inter)
    assert ut.is_player 
    ut.is_player = false
    assert ut.is_player_updated_to_false
    ut.is_player = true
    assert !ut.is_player_updated_to_false
    
    ut = user_teams(:saki_milan)
    assert !ut.is_player 
    ut.is_player = false
    assert !ut.is_player_updated_to_false
    ut.is_player = true
    assert !ut.is_player_updated_to_false
  end
  
  def test_depedency_update_positions_when_set_not_player
    MatchJoin.destroy_all   
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    MatchJoin.create_joins(matches(:one))
    mj1 = MatchJoin.find_by_match_id_and_team_id_and_user_id(matches(:one),teams(:inter),users(:saki))
    mj1.status = MatchJoin::JOIN
    mj1.position = 1;
    mj1.save!    
    matches(:two).start_time = 1.day.ago
    matches(:two).half_match_length = 25
    matches(:two).rest_length = 10
    matches(:two).save!
    MatchJoin.create_joins(matches(:two))
    mj2 = MatchJoin.find_by_match_id_and_team_id_and_user_id(matches(:two),teams(:inter),users(:saki))
    mj2.status = MatchJoin::JOIN
    mj2.position = 1;
    mj2.save!
    
    SidedMatchJoin.destroy_all
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    SidedMatchJoin.create_joins(sided_matches(:one))
    smj1 = SidedMatchJoin.find_by_match_id_and_user_id(sided_matches(:one) ,users(:saki))
    smj1.status = SidedMatchJoin::JOIN
    smj1.position = 1;
    smj1.save!
    sided_matches(:two).start_time = 1.day.ago
    sided_matches(:two).half_match_length = 25
    sided_matches(:two).rest_length = 10
    sided_matches(:two).save!
    SidedMatchJoin.create_joins(sided_matches(:two))
    smj2 = SidedMatchJoin.find_by_match_id_and_user_id(sided_matches(:two) ,users(:saki))
    smj2.status = SidedMatchJoin::JOIN
    smj2.position = 1;
    smj2.save!
    
    ut = user_teams(:saki_inter)
    ut.is_player = true
    ut.save!
    assert_equal 1, mj1.reload.position
    assert_equal 1, mj2.reload.position
    assert_equal 1, smj1.reload.position
    assert_equal 1, smj2.reload.position
    
    ut = user_teams(:saki_inter)
    ut.is_player = false
    ut.save!
    assert_equal nil, mj1.reload.position
    assert_equal 1, mj2.reload.position
    assert_equal nil, smj1.reload.position
    assert_equal 1, smj2.reload.position
  end
  
  def test_depedency_observer #入队退队时的级联修改
    MatchJoin.destroy_all   
    matches(:one).start_time = Time.now.tomorrow
    matches(:one).half_match_length = 25
    matches(:one).rest_length = 10
    matches(:one).save!
    MatchJoin.create_joins(matches(:one))
    mj = MatchJoin.find_by_match_id_and_team_id_and_user_id(matches(:one),teams(:inter),users(:saki))
    mj.status = MatchJoin::JOIN
    mj.save!
    matches(:two).start_time = 1.day.ago
    matches(:two).half_match_length = 25
    matches(:two).rest_length = 10
    matches(:two).save!
    MatchJoin.create_joins(matches(:two))
    mj = MatchJoin.find_by_match_id_and_team_id_and_user_id(matches(:two),teams(:inter),users(:saki))
    mj.status = MatchJoin::JOIN
    mj.save!
    
    SidedMatchJoin.destroy_all
    sided_matches(:one).start_time = Time.now.tomorrow
    sided_matches(:one).half_match_length = 25
    sided_matches(:one).rest_length = 10
    sided_matches(:one).save!
    SidedMatchJoin.create_joins(sided_matches(:one))
    smj1 = SidedMatchJoin.find_by_match_id_and_user_id(sided_matches(:one) ,users(:saki))
    smj1.status = SidedMatchJoin::JOIN
    smj1.position = 1;
    smj1.save!
    sided_matches(:two).start_time = 1.day.ago
    sided_matches(:two).half_match_length = 25
    sided_matches(:two).rest_length = 10
    sided_matches(:two).save!
    SidedMatchJoin.create_joins(sided_matches(:two))
    smj2 = SidedMatchJoin.find_by_match_id_and_user_id(sided_matches(:two) ,users(:saki))
    smj2.status = SidedMatchJoin::JOIN
    smj2.position = 1;
    smj2.save!
    
    assert trainings(:training1).has_joined_member?(users(:saki))
    assert trainings(:training4).has_joined_member?(users(:saki))
    assert matches(:one).has_joined_team_member?(users(:saki),teams(:inter))
    assert matches(:two).has_joined_team_member?(users(:saki),teams(:inter))
    assert sided_matches(:one).has_joined_member?(users(:saki))
    assert sided_matches(:two).has_joined_member?(users(:saki))
    
    assert_difference("SidedMatchJoin.find_all_by_user_id(users(:saki)).size", -1) do
    assert_difference("MatchJoin.find_all_by_team_id_and_user_id(teams(:inter),users(:saki)).size", -1) do
    assert_difference("users(:saki).trainings.reload.size", -2) do
      user_teams(:saki_inter).destroy
    end
    end
    end
    assert_equal 2, users(:saki).trainings.reload.size
    assert trainings(:training1).has_joined_member?(users(:saki))
    assert !trainings(:training4).has_member?(users(:saki))
    assert !matches(:one).has_team_member?(users(:saki),teams(:inter))
    assert matches(:two).has_joined_team_member?(users(:saki),teams(:inter))
    assert !sided_matches(:one).has_member?(users(:saki))
    assert sided_matches(:two).has_joined_member?(users(:saki))
    
    assert_difference("SidedMatchJoin.find_all_by_user_id(users(:saki)).size", 1) do
    assert_difference("MatchJoin.find_all_by_team_id_and_user_id(teams(:inter),users(:saki)).size", 1) do
    assert_difference("users(:saki).trainings.reload.size", 2) do
      ut = UserTeam.new
      ut.user = users(:saki)
      ut.team = teams(:inter)
      ut.save!
    end
    end
    end
    assert_equal 4, users(:saki).trainings.reload.size
    assert trainings(:training1).has_joined_member?(users(:saki))
    assert trainings(:training4).has_member?(users(:saki))
    assert !trainings(:training4).has_joined_member?(users(:saki))
    assert matches(:one).has_team_member?(users(:saki),teams(:inter))
    assert !matches(:one).has_joined_team_member?(users(:saki),teams(:inter))
    assert matches(:two).has_joined_team_member?(users(:saki),teams(:inter))
    assert sided_matches(:one).has_member?(users(:saki))
    assert !sided_matches(:one).has_joined_member?(users(:saki))
    assert sided_matches(:two).has_joined_member?(users(:saki))
    
    Training.destroy_all
    Match.destroy_all
    SidedMatch.destroy_all
    assert_no_difference("SidedMatchJoin.find_all_by_user_id(users(:saki)).size") do
    assert_no_difference("MatchJoin.find_all_by_team_id_and_user_id(teams(:inter),users(:saki)).size") do
    assert_no_difference("users(:saki).trainings.reload.size") do
      user_teams(:saki_inter).destroy
    end
    end
    end
    
    assert_no_difference("SidedMatchJoin.find_all_by_user_id(users(:saki)).size") do
    assert_no_difference("MatchJoin.find_all_by_team_id_and_user_id(teams(:inter),users(:saki)).size") do
    assert_no_difference("users(:saki).trainings.reload.size") do
      ut = UserTeam.new
      ut.user = users(:saki)
      ut.team = teams(:inter)
      ut.save!
    end
    end
    end
  end
  
  def test_admin_operation
    assert !user_teams(:saki_inter).is_the_only_one_admin?
    assert user_teams(:saki_milan).is_the_only_one_admin?
    assert !user_teams(:aaron_milan).is_the_only_one_admin?
    
    assert_equal true, user_teams(:aaron_milan).can_promote_as_admin_by?(users(:saki))
    assert_equal false, user_teams(:aaron_milan).can_promote_as_admin_by?(users(:quentin))
    
    assert_equal true, user_teams(:saki_inter).can_degree_as_common_user_by?(users(:quentin))
    assert_equal true, user_teams(:saki_inter).can_degree_as_common_user_by?(users(:saki))
    assert_equal false, user_teams(:saki_inter).can_degree_as_common_user_by?(users(:aaron))
    assert_equal false, user_teams(:saki_milan).can_degree_as_common_user_by?(users(:saki))
  end
  
  def test_max_admins_operation
    teams_array = []
    (1..21).each do |i|
       teams_array << Team.create!(:name => 'Test', :shortname => 'test')
    end
    (0..19).each do |i|
      ut = UserTeam.new(:is_admin => true)
      ut.user_id = users(:aaron).id
      ut.team_id = teams_array[i].id
      ut.save!
    end
    assert_equal false, user_teams(:aaron_milan).can_promote_as_admin_by?(users(:saki))
  end
  
  def test_can_destroy
    assert user_teams(:aaron_milan).can_destroy_by?(users(:saki))
    assert user_teams(:aaron_milan).can_destroy_by?(users(:aaron))
    assert !user_teams(:aaron_milan).can_destroy_by?(users(:mike1))
    assert !user_teams(:saki_milan).can_destroy_by?(users(:saki))
  end
  
  def test_no_accessible
    @t = user_teams(:saki_inter)
    uid = @t.user_id
    tid = @t.team_id
    pos = @t.position
    @t.update_attributes!(:team_id=>3, :user_id=>1, :position=>pos+1)
    assert_equal tid, @t.team_id
    assert_equal uid, @t.user_id
    assert_equal pos, @t.position
  end
  
  def test_team_positions
    assert 2, UserTeam.team_formation(teams(:inter))
  end
  
  def test_validation
    ut = UserTeam.new(:is_player=>true, :position => '')
    assert ut.valid?
    assert_nil ut.position
    user_teams(:quentin_inter).is_player = false
    user_teams(:quentin_inter).save!
    assert_nil user_teams(:quentin_inter).position
    user_teams(:quentin_inter).is_player = true
    user_teams(:quentin_inter).position = 26
    assert !user_teams(:quentin_inter).valid?
  end
  
  def test_admin_before_save
    UserTeam.destroy_all
    Team.destroy_all
    teams_array = []
    (1..21).each do |i|
       teams_array << Team.create!(:name => 'Test', :shortname => 'test')
    end
    assert_equal 0, UserTeam.count
    assert_equal 21, Team.count
    (0..19).each do |i|
      ut = UserTeam.new(:is_admin => true)
      ut.user_id = users(:saki).id
      ut.team_id = teams_array[i].id
      ut.save!
    end
    assert_equal UserTeam::MAX_ADMIN_LENGTH, users(:saki).teams.admin.length
    
    ut = UserTeam.new(:is_admin => true)
    ut.user_id = users(:saki).id
    ut.team_id = teams_array[20].id
    assert !ut.save
    assert_equal UserTeam::MAX_ADMIN_LENGTH, users(:saki).teams.admin.length
    
    ut = UserTeam.new(:is_admin => false)
    ut.user_id = users(:saki).id
    ut.team_id = teams_array[20].id
    ut.save!
    ut.is_admin = true;
    ut.save!
    assert !ut.is_admin
    assert_equal UserTeam::MAX_ADMIN_LENGTH, users(:saki).teams.admin.length
    
    ut = UserTeam.find_by_user_id_and_team_id users(:saki).id, teams_array[1].id
    ut.is_admin = false
    ut.save!
    assert ut.is_admin;
    assert_equal UserTeam::MAX_ADMIN_LENGTH, users(:saki).teams.admin.length
    
    ut = UserTeam.find_by_user_id_and_team_id users(:saki).id, teams_array[1].id
    ut.is_player = true
    ut.save!
    assert ut.is_admin;
    assert_equal UserTeam::MAX_ADMIN_LENGTH, users(:saki).teams.admin.length
  end
end

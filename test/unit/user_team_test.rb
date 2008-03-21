require File.dirname(__FILE__) + '/../test_helper'

class UserTeamTest < ActiveSupport::TestCase
  def test_admin_operation
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
    @t.update_attributes!(:team_id=>3, :user_id=>1)
    assert_equal tid, @t.team_id
    assert_equal uid, @t.user_id
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
  
  def test_after_save
    user_teams(:saki_inter).position = 3
    user_teams(:saki_inter).save!
    assert_nil user_teams(:quentin_inter).position
  end
  
  def test_position_before_save
    UserTeam.destroy_all
    assert_equal 0, UserTeam.count
    (1..11).each do |i|
      ut = UserTeam.new(:is_player => true, :position => i)
      ut.user_id = i
      ut.team_id = 1
      ut.save!
    end
    assert_equal UserTeam::FORMATION_MAX_LENGTH, UserTeam.team_formation(1).size
    ut = UserTeam.new(:is_player => true, :position => 12)
    ut.user_id = 12
    ut.team_id = 1
    ut.save!
    assert_nil ut.position
    assert_equal UserTeam::FORMATION_MAX_LENGTH, UserTeam.team_formation(1).size
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
    ut.save!
    assert !ut.is_admin;
    assert_equal UserTeam::MAX_ADMIN_LENGTH, users(:saki).teams.admin.length
    ut = UserTeam.find_by_user_id_and_team_id users(:saki).id, teams_array[1].id
    ut.is_player = true
    ut.save!
    assert ut.is_admin;
    assert_equal UserTeam::MAX_ADMIN_LENGTH, users(:saki).teams.admin.length
  end
end

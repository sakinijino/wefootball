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
    @t.update_attributes(:team_id=>3, :user_id=>1)
    assert_equal tid, @t.team_id
    assert_equal uid, @t.user_id
  end
  
  def test_team_positions
    assert 2, UserTeam.team_positions(teams(:inter))
  end
  
  def test_before_save
    user_teams(:saki_inter).position = 'SW'
    user_teams(:saki_inter).save
    assert_nil user_teams(:quentin_inter).position
    user_teams(:saki_inter).is_player = false
    user_teams(:saki_inter).save
    assert_nil user_teams(:saki_inter).position
  end
end

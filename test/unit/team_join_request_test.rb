require File.dirname(__FILE__) + '/../test_helper'

class TeamJoinRequestTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_thourgh
    assert_equal 1, users(:aaron).request_join_teams.length
    assert_equal 1,  users(:saki).invited_join_teams.length
    
    assert_equal 3,  teams(:inter).invited_join_users.length
    assert_equal 1,  teams(:inter).request_join_users.length
    assert_equal 2,  teams(:milan).request_join_users.length
  end
  
  def test_create
    assert_difference 'TeamJoinRequest.count' do
      t = create_request
      assert_equal t.message, ''
      assert_equal t.is_invitation, false
      assert_not_nil t.apply_date
    end
  end
  
  def test_can
    assert team_join_requests(:mike1_inter).can_destroy_by?(users(:mike1))
    assert team_join_requests(:mike1_inter).can_destroy_by?(users(:saki))
    assert !team_join_requests(:mike1_inter).can_destroy_by?(users(:mike2))
    
    assert team_join_requests(:mike1_inter).can_accept_by?(users(:mike1))
    assert !team_join_requests(:mike1_inter).can_accept_by?(users(:saki))
    assert !team_join_requests(:mike1_inter).can_accept_by?(users(:mike2))
    
    assert team_join_requests(:mike2_inter).can_accept_by?(users(:saki))
    assert !team_join_requests(:mike2_inter).can_accept_by?(users(:mike2))
    assert !team_join_requests(:mike2_inter).can_accept_by?(users(:mike1))
  end
  
protected
  def create_request
    t = TeamJoinRequest.new
    t.user = users(:aaron)
    t.team = teams(:inter)
    t.save
    return t
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class TeamJoinRequestTest < ActiveSupport::TestCase
  
  def test_create
    assert_difference 'TeamJoinRequest.count' do
      t = create_request
      assert_equal 150, t.message.length
      assert_equal false, t.is_invitation
      assert_equal Date.today, t.apply_date
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
  
  def test_no_accessible
    t = team_join_requests(:saki_inter)
    tid = t.team_id
    uid = t.user_id
    t.update_attributes!(:team_id=>10, :user_id=>10, :message=>'Modified')
    assert_equal tid, t.team_id
    assert_equal uid, t.user_id
    assert_equal 'Modified', t.message
  end
  
  def test_team_join_invitations_count
    t = TeamJoinRequest.new
    assert_difference "users(:aaron).reload.team_join_invitations_count", 1 do
    assert_no_difference "teams(:inter).reload.team_join_requests_count" do
      t.user = users(:aaron)
      t.team = teams(:inter)
      t.is_invitation = true
      t.save!
    end
    end
    
    assert_difference "users(:aaron).reload.team_join_invitations_count", -1 do
    assert_no_difference "teams(:inter).reload.team_join_requests_count" do
      t.destroy
    end
    end
  end
  
  def test_team_join_requests_count
    t = TeamJoinRequest.new
    assert_no_difference "users(:aaron).reload.team_join_invitations_count" do
    assert_difference "teams(:inter).reload.team_join_requests_count", 1 do
      t.user = users(:aaron)
      t.team = teams(:inter)
      t.is_invitation = false
      t.save!
    end
    end
    
    assert_no_difference "users(:aaron).reload.team_join_invitations_count" do
    assert_difference "teams(:inter).reload.team_join_requests_count", -1 do
      t.destroy
    end
    end
  end
  
protected
  def create_request
    t = TeamJoinRequest.new
    t.message = 's'*1000
    t.user = users(:aaron)
    t.team = teams(:inter)
    t.save!
    return t
  end
end

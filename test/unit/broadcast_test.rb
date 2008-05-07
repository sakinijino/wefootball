require File.dirname(__FILE__) + '/../test_helper'

class BroadcastTest < ActiveSupport::TestCase
  def test_observers
    user1_id = 10
    user2_id = 11
    team_id = 12
    match_id = 13
    play_id = 14
    
    assert_equal 0, FriendCreationBroadcast.count  
    fr = FriendRelation.create!(:user1_id=>user1_id, :user2_id=>user2_id)
    #生成对称的两条广播
    assert_equal 2, FriendCreationBroadcast.count
    assert_equal user2_id, FriendCreationBroadcast.find_by_user_id(user1_id).friend_id
    assert_equal user1_id, FriendCreationBroadcast.find_by_user_id(user2_id).friend_id    
    
    assert_equal 0, MatchCreationBroadcast.count
    mi = match_invitations(:inv1)
    m = Match.create_by_invitation(mi)
    #生成对称的两条广播    
    assert_equal 2, MatchCreationBroadcast.count
    assert_equal m.id, MatchCreationBroadcast.find_by_team_id(mi.host_team_id).activity_id
    assert_equal m.id, MatchCreationBroadcast.find_by_team_id(mi.guest_team_id).activity_id
    
    assert_equal 0, MatchJoinBroadcast.count
    mj = MatchJoin.new
    mj.user_id = user1_id
    mj.team_id = team_id
    mj.match_id = match_id
    mj.save!
    assert_equal 1, MatchJoinBroadcast.count
    assert_equal team_id, MatchJoinBroadcast.find_by_user_id(user1_id).team_id
    assert_equal match_id, MatchJoinBroadcast.find_by_user_id(user1_id).activity_id

    assert_equal 0, PlayJoinBroadcast.count
    pj = PlayJoin.new
    pj.user_id = user1_id
    pj.play_id = play_id
    pj.save!
    assert_equal 1, PlayJoinBroadcast.count
    assert_equal play_id, PlayJoinBroadcast.find_by_user_id(user1_id).activity_id
    
    assert_equal 0, SidedMatchCreationBroadcast.count
    m = SidedMatch.new
    m.host_team_id = team_id
    m.guest_team_name = "AC"
    m.location = "Beijing"
    m.start_time = 1.day.since
    m.half_match_length = 45
    m.rest_length = 15
    m.save!
    assert_equal 1, SidedMatchCreationBroadcast.count
    assert_equal m.id, SidedMatchCreationBroadcast.find_by_team_id(team_id).activity_id
    
    assert_equal 0, TrainingCreationBroadcast.count
    t = Training.new({:football_ground_id=>football_grounds(:yiti).id})
    t.team = teams(:inter)
    t.save!
    assert_equal 1, TrainingCreationBroadcast.count
    assert_equal t.id, TrainingCreationBroadcast.find_by_team_id(teams(:inter).id).activity_id

    TrainingJoinBroadcast.destroy_all
    assert_equal 0, TrainingJoinBroadcast.count
    tj = TrainingJoin.new
    tj.user_id = user1_id
    tj.training_id = t.id
    tj.save!
    assert_equal 1, TrainingJoinBroadcast.count
    assert_equal t.id, TrainingJoinBroadcast.find_by_user_id(user1_id).activity_id    
  end
end

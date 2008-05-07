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

    assert_equal 0, TeamJoinBroadcast.count  
    ut = UserTeam.new
    ut.user_id = user1_id
    ut.team_id = team_id
    ut.save!
    #生成对称的两条广播
    assert_equal 1, TeamJoinBroadcast.count
    assert_equal team_id, TeamJoinBroadcast.find_by_user_id(user1_id).team_id   
    
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
    mj.status = MatchJoin::JOIN
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

    assert_equal 0, SidedMatchJoinBroadcast.count
    mj = SidedMatchJoin.new
    mj.user_id = user1_id
    mj.match_id = m.id
    mj.status = SidedMatchJoin::JOIN
    mj.save!
    assert_equal 1, SidedMatchJoinBroadcast.count
    assert_equal m.id, SidedMatchJoinBroadcast.find_by_user_id(user1_id).activity_id   
    
    assert_equal 0, TrainingCreationBroadcast.count
    t = Training.new({:football_ground_id=>football_grounds(:yiti).id})
    t.team = teams(:inter)
    t.save!
    assert_equal 1, TrainingCreationBroadcast.count
    assert_equal t.id, TrainingCreationBroadcast.find_by_team_id(teams(:inter).id).activity_id

    assert_equal 0, TrainingJoinBroadcast.count
    tj = TrainingJoin.new
    tj.user_id = user1_id
    tj.training_id = t.id
    tj.status = TrainingJoin::JOIN    
    tj.save!
    assert_equal 1, TrainingJoinBroadcast.count
    assert_equal t.id, TrainingJoinBroadcast.find_by_user_id(user1_id).activity_id    
  end
  
  def test_get_related_broadcasts
    #在夹具数据中,aaron和saki是朋友,是milan的成员
    #saki和mike成为朋友
    FriendRelation.create!(:user1_id=>users(:saki).id, :user2_id=>users(:mike1).id)    
    #aaron加入了juven
    ut1 = UserTeam.new
    ut1.user_id = users(:aaron).id
    ut1.team_id = teams(:juven).id
    ut1.save!    
    #mike加入了inter
    ut2 = UserTeam.new
    ut2.user_id = users(:mike1).id
    ut2.team_id = teams(:inter).id
    ut2.save!      
    #inter建了一次训练
    t1 = Training.new({:football_ground_id=>football_grounds(:yiti).id})
    t1.team = teams(:inter)
    t1.save!    
    #milan建了一次训练
    t2 = Training.new({:football_ground_id=>football_grounds(:yiti).id})
    t2.team = teams(:milan)
    t2.save!
    assert_equal 3, Broadcast.get_related_broadcasts(users(:aaron)).size
  end
  
  def test_reject_redundance
    #在夹具数据中,saki与aaron和mike2都是朋友
    #saki是milan和juven的成员
    #aaron是milan的成员    
    FriendRelation.create!(:user1_id=>users(:aaron).id, :user2_id=>users(:mike2).id)
    assert_equal 1, Broadcast.get_related_broadcasts(users(:saki)).size
    assert_equal 1, Broadcast.get_related_broadcasts(users(:aaron)).size
    assert_equal 1, Broadcast.get_related_broadcasts(users(:mike2)).size    
    
    mi = match_invitations(:inv1)
    mi.host_team_id = teams(:milan).id
    mi.guest_team_id = teams(:juven).id    
    m = Match.create_by_invitation(mi)
    assert_equal 2, Broadcast.get_related_broadcasts(users(:saki)).size
    assert_equal 2, Broadcast.get_related_broadcasts(users(:aaron)).size
    assert_equal 1, Broadcast.get_related_broadcasts(users(:mike2)).size    
  end  
end

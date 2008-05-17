require File.dirname(__FILE__) + '/../test_helper'

class BroadcastTest < ActiveSupport::TestCase
  def test_observers
    user1_id = 10
    user2_id = 11
    team_id = 12
    match_id = 13
    play_id = 14
    watch_id = 15
    
    assert_equal 0, FriendCreationBroadcast.count  
    FriendRelation.create!(:user1_id=>user1_id, :user2_id=>user2_id)
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

    assert_equal 0, WatchJoinBroadcast.count
    wj = WatchJoin.new
    wj.user_id = user1_id
    wj.watch_id = watches(:one).id   
    wj.save!
    assert_equal 1, WatchJoinBroadcast.count
    assert_equal watches(:one).id, WatchJoinBroadcast.find_by_user_id(user1_id).activity_id     

    assert_equal 0, MatchReviewCreationBroadcast.count
    mr = MatchReview.new
    mr.user_id = user1_id
    mr.match_id = sided_matches(:one).id
    mr.save_without_validation
    assert_equal 1, MatchReviewCreationBroadcast.count
    assert_equal mr.id, MatchReviewCreationBroadcast.find_by_user_id(user1_id).activity_id
    
    assert_equal 0, MatchReviewRecommendationBroadcast.count
    mrr = MatchReviewRecommendation.new
    mrr.user_id = user1_id
    mrr.match_review_id = match_reviews(:saki_1).id
    mrr.status = 1
    mrr.save!
    assert_equal 1, MatchReviewRecommendationBroadcast.count
    assert_equal watches(:one).id, MatchReviewRecommendationBroadcast.find_by_user_id(user1_id).activity_id     
  end
  
  def test_destory_dependency
    FriendCreationBroadcast.create!(:user_id => users(:saki).id, :friend_id=>users(:mike1).id)
    MatchCreationBroadcast.create!(:team_id => teams(:inter).id, :activity_id=>matches(:one).id)
    MatchJoinBroadcast.create!(:user_id => users(:saki).id, :team_id => teams(:inter).id, :activity_id=>matches(:one).id)
    PlayJoinBroadcast.create!(:user_id => users(:saki).id, :activity_id=>plays(:play1).id)
    SidedMatchCreationBroadcast.create!(:team_id => teams(:inter).id, :activity_id=>sided_matches(:one).id)
    SidedMatchJoinBroadcast.create!(:user_id => users(:saki).id, :team_id => teams(:inter).id, :activity_id=>sided_matches(:one).id)
    TrainingCreationBroadcast.create!(:team_id => teams(:inter).id, :activity_id=>trainings(:training1).id)
    TrainingJoinBroadcast.create!(:user_id => users(:saki).id, :team_id => teams(:inter).id, :activity_id=>trainings(:training1).id)
    
    assert_difference('Broadcast.count', -1) do
    assert_difference('FriendCreationBroadcast.count', -1) do
      users(:mike1).destroy
    end
    end
    
    assert_difference('Broadcast.count', -2) do
    assert_difference('MatchJoinBroadcast.count', -1) do
    assert_difference('MatchCreationBroadcast.count', -1) do
      matches(:one).destroy
    end
    end
    end
    
    assert_difference('Broadcast.count', -1) do
    assert_difference('PlayJoinBroadcast.count', -1) do
      plays(:play1).destroy
    end
    end
    
    assert_difference('Broadcast.count', -2) do
    assert_difference('SidedMatchCreationBroadcast.count', -1) do
    assert_difference('SidedMatchJoinBroadcast.count', -1) do
      sided_matches(:one).destroy
    end
    end
    end
    
    assert_difference('Broadcast.count', -2) do
    assert_difference('TrainingCreationBroadcast.count', -1) do
    assert_difference('TrainingJoinBroadcast.count', -1) do
      trainings(:training1).destroy
    end
    end
    end
    
    FriendCreationBroadcast.create!(:user_id => users(:saki).id, :friend_id=>users(:mike1).id)
    MatchJoinBroadcast.create!(:user_id => users(:saki).id, :team_id => teams(:inter).id, :activity_id=>matches(:one).id)
    PlayJoinBroadcast.create!(:user_id => users(:saki).id, :activity_id=>plays(:play1).id)
    SidedMatchJoinBroadcast.create!(:user_id => users(:saki).id, :team_id => teams(:inter).id, :activity_id=>sided_matches(:one).id)
    TeamJoinBroadcast.create!(:user_id => users(:saki).id, :team_id => teams(:inter).id)
    TrainingJoinBroadcast.create!(:user_id => users(:saki).id, :team_id => teams(:inter).id, :activity_id=>trainings(:training1).id)
    
    assert_difference('Broadcast.count', -6) do
    assert_difference('FriendCreationBroadcast.count', -1) do
    assert_difference('MatchJoinBroadcast.count', -1) do
    assert_difference('PlayJoinBroadcast.count', -1) do
    assert_difference('SidedMatchJoinBroadcast.count', -1) do
    assert_difference('TeamJoinBroadcast.count', -1) do
    assert_difference('TrainingJoinBroadcast.count', -1) do
      users(:saki).destroy
    end
    end
    end
    end
    end
    end
    end
    
    MatchCreationBroadcast.create!(:team_id => teams(:inter).id, :activity_id=>matches(:one).id)
    MatchJoinBroadcast.create!(:user_id => users(:saki).id, :team_id => teams(:inter).id, :activity_id=>matches(:one).id)
    SidedMatchCreationBroadcast.create!(:team_id => teams(:inter).id, :activity_id=>sided_matches(:one).id)
    SidedMatchJoinBroadcast.create!(:user_id => users(:saki).id, :team_id => teams(:inter).id, :activity_id=>sided_matches(:one).id)
    TeamJoinBroadcast.create!(:user_id => users(:saki).id, :team_id => teams(:inter).id)
    TrainingCreationBroadcast.create!(:team_id => teams(:inter).id, :activity_id=>trainings(:training1).id)
    TrainingJoinBroadcast.create!(:user_id => users(:saki).id, :team_id => teams(:inter).id, :activity_id=>trainings(:training1).id)
    
    assert_difference('Broadcast.count', -7) do
    assert_difference('MatchCreationBroadcast.count', -1) do
    assert_difference('MatchJoinBroadcast.count', -1) do
    assert_difference('SidedMatchCreationBroadcast.count', -1) do
    assert_difference('SidedMatchJoinBroadcast.count', -1) do
    assert_difference('TeamJoinBroadcast.count', -1) do
    assert_difference('TrainingCreationBroadcast.count', -1) do
    assert_difference('TrainingJoinBroadcast.count', -1) do
      teams(:inter).destroy
    end
    end
    end
    end
    end
    end
    end
    end
  end
  
  def test_cascade_destroy_in_watch_and_match_review_and_recommendation_broadcast

    MatchReviewCreationBroadcast.create!(:user_id => users(:saki).id, :activity_id=>sided_matches(:one).id)
    MatchReviewRecommendationBroadcast.create!(:user_id => users(:saki).id, :activity_id=>match_reviews(:saki_1).id)    
    assert_difference('Broadcast.count', -2) do
    assert_difference('MatchReviewCreationBroadcast.count', -1) do
    assert_difference('MatchReviewRecommendationBroadcast.count', -1) do      
      sided_matches(:one).destroy
    end
    end
    end
    
    WatchJoinBroadcast.create!(:user_id => users(:saki).id, :activity_id=>watches(:one).id)
    assert_difference('WatchJoinBroadcast.count', -1) do
      official_matches(:one).destroy
    end 

    
    WatchJoinBroadcast.create!(:user_id => users(:saki).id, :activity_id=>watches(:one).id)
    MatchReviewCreationBroadcast.create!(:user_id => users(:saki).id, :activity_id=>matches(:one).id)
    MatchReviewRecommendationBroadcast.create!(:user_id => users(:saki).id, :activity_id=>matches(:one).id)    
    assert_difference('Broadcast.count', -3) do
    assert_difference('WatchJoinBroadcast.count', -1) do
    assert_difference('MatchReviewCreationBroadcast.count', -1) do
    assert_difference('MatchReviewRecommendationBroadcast.count', -1) do      
      users(:saki).destroy
    end
    end
    end
    end
    
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
    assert_equal 1, Broadcast.get_related_broadcasts(users(:aaron), :page=>2, :per_page=>1).size
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

  def test_correctly_generate_match_review_recommendation_broadcast
    assert_equal 0, MatchReviewRecommendationBroadcast.count
    mrr = MatchReviewRecommendation.new
    mrr.user_id = 1
    mrr.match_review_id = match_reviews(:saki_1).id
    mrr.status = 0
    mrr.save!
    assert_equal 0, MatchReviewRecommendationBroadcast.count
    mrr.status = 1
    mrr.save!    
    assert_equal 1, MatchReviewRecommendationBroadcast.count
    assert_equal watches(:one).id, MatchReviewRecommendationBroadcast.find_by_user_id(1).activity_id
    mrr.status = 0
    mrr.save!    
    assert_equal 1, MatchReviewRecommendationBroadcast.count #广播数目没有增加
    mrr.status = 1
    mrr.save!    
    assert_equal 2, MatchReviewRecommendationBroadcast.count #增加一条广播（实际中应该不存在这种情况）   
  end  
  
  def test_correctly_generate_match_join_broadcast
    mi = match_invitations(:inv1)
    mi.host_team_id = teams(:milan).id
    mi.guest_team_id = teams(:inter).id  
    m = Match.create_by_invitation(mi)    
    
    mj1 = MatchJoin.new
    mj1.user_id = users(:saki).id
    mj1.team_id = teams(:inter).id
    mj1.match_id = m.id    
    mj2 = MatchJoin.new
    mj2.user_id = users(:aaron).id
    mj2.team_id = teams(:milan).id
    mj2.match_id = m.id
    mj3 = MatchJoin.new    
  
    #1.创建状态为join的参加
    assert_difference('MatchJoinBroadcast.count', 1) do
      mj1.status = MatchJoin::JOIN
      mj1.save!
    end      
    #2.创建状态为undetermined的参加
    assert_no_difference('MatchJoinBroadcast.count') do
      mj2.status = MatchJoin::UNDETERMINED
      mj2.save!
    end   
    #3.状态从join转为unjoin
    assert_no_difference('MatchJoinBroadcast.count') do
      assert_equal MatchJoin::JOIN, mj1.status
      mj1.destroy
    end
    #4.状态从unjoin转为join
    assert_difference('MatchJoinBroadcast.count', 1) do
      mj3.user_id = mj1.user_id
      mj3.team_id = mj1.team_id
      mj3.match_id = m.id        
      mj3.status = MatchJoin::JOIN
      mj3.save!
    end     
    #4.状态从join转为join
    assert_no_difference('MatchJoinBroadcast.count') do      
      mj3.status = MatchJoin::JOIN
      mj3.save!
    end 
    #undetermined -> join
    assert_difference('MatchJoinBroadcast.count', 1) do
      assert_equal MatchJoin::UNDETERMINED, mj2.status      
      mj2.status = MatchJoin::JOIN
      mj2.save!
    end
  end
  
  def test_correctly_generate_sided_match_join_broadcast
    m = SidedMatch.new
    m.host_team_id = teams(:milan).id
    m.guest_team_name = '国米'
    m.location = '一体'
    m.save!

    mj1 = SidedMatchJoin.new
    mj1.user_id = users(:saki).id
    mj1.match_id = m.id
    mj2 = SidedMatchJoin.new
    mj2.user_id = users(:aaron).id
    mj2.match_id = m.id
    mj3 = SidedMatchJoin.new    
  
    #1.创建状态为join的参加
    assert_difference('SidedMatchJoinBroadcast.count', 1) do
      mj1.status = SidedMatchJoin::JOIN
      mj1.save!
    end      
    #2.创建状态为undetermined的参加
    assert_no_difference('SidedMatchJoinBroadcast.count') do
      mj2.status = SidedMatchJoin::UNDETERMINED
      mj2.save!
    end   
    #3.状态从join转为unjoin
    assert_no_difference('SidedMatchJoinBroadcast.count') do
      assert_equal SidedMatchJoin::JOIN, mj1.status
      mj1.destroy
    end
    #4.状态从unjoin转为join
    assert_difference('SidedMatchJoinBroadcast.count', 1) do
      mj3.user_id = mj1.user_id
      mj3.match_id = m.id        
      mj3.status = SidedMatchJoin::JOIN
      mj3.save!
    end     
    #4.状态从join转为join
    assert_no_difference('SidedMatchJoinBroadcast.count') do      
      mj3.status = SidedMatchJoin::JOIN
      mj3.save!
    end 
    #undetermined -> join
    assert_difference('SidedMatchJoinBroadcast.count', 1) do
      assert_equal SidedMatchJoin::UNDETERMINED, mj2.status      
      mj2.status = SidedMatchJoin::JOIN
      mj2.save!
    end
  end
  
  def test_correctly_generate_training_join_broadcast
    t = Training.new
    t.team_id = teams(:milan).id
    t.location = '一体'    
    t.save!

    tj1 = TrainingJoin.new
    tj1.user_id = users(:saki).id
    tj1.training_id = t.id
    tj2 = TrainingJoin.new
    tj2.user_id = users(:aaron).id
    tj2.training_id = t.id
    tj3 = TrainingJoin.new    
  
    #1.创建状态为join的参加
    assert_difference('TrainingJoinBroadcast.count', 1) do
      tj1.status = TrainingJoin::JOIN
      tj1.save!
    end      
    #2.创建状态为undetermined的参加
    assert_no_difference('TrainingJoinBroadcast.count') do
      tj2.status = TrainingJoin::UNDETERMINED
      tj2.save!
    end   
    #3.状态从join转为unjoin
    assert_no_difference('TrainingJoinBroadcast.count') do
      assert_equal TrainingJoin::JOIN, tj1.status
      tj1.destroy
    end
    #4.状态从unjoin转为join
    assert_difference('TrainingJoinBroadcast.count', 1) do
      tj3.user_id = tj1.user_id
      tj3.training_id = t.id        
      tj3.status = TrainingJoin::JOIN
      tj3.save!
    end     
    #4.状态从join转为join
    assert_no_difference('TrainingJoinBroadcast.count') do      
      tj3.status = TrainingJoin::JOIN
      tj3.save!
    end 
    #undetermined -> join
    assert_difference('TrainingJoinBroadcast.count', 1) do
      assert_equal MatchJoin::UNDETERMINED, tj2.status      
      tj2.status = TrainingJoin::JOIN
      tj2.save!
    end
  end   
end

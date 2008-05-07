class UserTeamObserver < ActiveRecord::Observer
  def after_create(user_team)
    Training.find_all_by_team_id(user_team.team_id, 
      :conditions => ["start_time > ?", Time.now]).each do |training|
      tj = TrainingJoin.new
      tj.training_id = training.id
      tj.user_id = user_team.user_id
      tj.status = TrainingJoin::UNDETERMINED
      tj.save!
    end
    
    Match.find(:all,
      :conditions => ["(host_team_id = ? or guest_team_id = ?) and start_time > ?", 
        user_team.team_id, 
        user_team.team_id, 
        Time.now]).each do |match|
      mj = MatchJoin.new
      mj.match_id = match.id
      mj.team_id = user_team.team_id
      mj.user_id = user_team.user_id
      mj.status = MatchJoin::UNDETERMINED
      mj.save!
    end
    
    SidedMatch.find(:all,
      :conditions => ["host_team_id = ? and start_time > ?", 
        user_team.team_id, 
        Time.now]).each do |match|
      mj = SidedMatchJoin.new
      mj.match_id = match.id
      mj.user_id = user_team.user_id
      mj.status = SidedMatchJoin::UNDETERMINED
      mj.save!
    end
    
    bc = TeamJoinBroadcast.new
    bc.user_id = user_team.user_id
    bc.team_id = user_team.team_id
    bc.save!    
  end
  
  def after_destroy(user_team)
    tids = Training.find_all_by_team_id(user_team.team_id, 
      :conditions => ["start_time > ?", Time.now]).map {|t| t.id}
    TrainingJoin.destroy_all(["user_id = ? and (#{(['training_id = ?']*tids.size).join(' or ')})", 
        user_team.user_id, *tids]) if tids.size > 0
    
    mids = Match.find(:all,
      :conditions => ["(host_team_id = ? or guest_team_id = ?) and start_time > ?", 
        user_team.team_id, 
        user_team.team_id, 
        Time.now]).map {|t| t.id}
    MatchJoin.destroy_all(["user_id = ? and team_id = ? and (#{(['match_id = ?']*mids.size).join(' or ')})", 
        user_team.user_id, user_team.team_id, *mids]) if mids.size > 0
    
    mids = SidedMatch.find(:all,
      :conditions => ["host_team_id = ? and start_time > ?", 
        user_team.team_id, 
        Time.now]).map {|t| t.id}
    SidedMatchJoin.destroy_all(["user_id = ? and (#{(['match_id = ?']*mids.size).join(' or ')})", 
        user_team.user_id, *mids]) if mids.size > 0
  end
  
  def after_update(user_team)
    return if !user_team.is_player_changed_to_false
    mids = Match.find(:all,
      :conditions => ["(host_team_id = ? or guest_team_id = ?) and start_time > ?", 
        user_team.team_id, 
        user_team.team_id, 
        Time.now]).map {|t| t.id}
    MatchJoin.update_all(["position = ?", nil], 
      ["user_id = ? and team_id = ? and (#{(['match_id = ?']*mids.size).join(' or ')})", 
        user_team.user_id, user_team.team_id, *mids]) if mids.size > 0
    
    mids = SidedMatch.find(:all,
      :conditions => ["host_team_id = ? and start_time > ?", 
        user_team.team_id, 
        Time.now]).map {|t| t.id}
    SidedMatchJoin.update_all(["position = ?", nil], 
      ["user_id = ? and (#{(['match_id = ?']*mids.size).join(' or ')})", 
        user_team.user_id, *mids]) if mids.size > 0
  end
end

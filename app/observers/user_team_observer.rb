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
  end
  
  def after_destroy(user_team)
    tids = Training.find_all_by_team_id(user_team.team_id, 
      :conditions => ["start_time > ?", Time.now]).map {|t| t.id}
    TrainingJoin.destroy_all(["user_id = ? and (#{(['training_id = ?']*tids.size).join(' or ')})", 
        user_team.user_id, *tids]) if tids.size > 0
  end
end

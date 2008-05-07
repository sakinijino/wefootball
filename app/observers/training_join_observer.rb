class TrainingJoinObserver < ActiveRecord::Observer
  def after_save(training_join)
    if training_join.status == TrainingJoin::JOIN
      TrainingJoinBroadcast.create!(:user_id=>training_join.user_id,
                                    :team_id=>training_join.training.team_id,
                                    :activity_id=>training_join.training_id)
    end
  end 
end

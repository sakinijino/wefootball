class TrainingJoinObserver < ActiveRecord::Observer
  def before_save(training_join)
    if (training_join.status == TrainingJoin::JOIN) && 
        (training_join.new_record? || training_join.column_changed?(:status))
      TrainingJoinBroadcast.create!(:user_id=>training_join.user_id,
                                    :team_id=>training_join.training.team_id,
                                    :activity_id=>training_join.training_id)
    end
  end 
end

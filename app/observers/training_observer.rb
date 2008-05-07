class TrainingObserver < ActiveRecord::Observer
  def after_create(training)
    TrainingCreationBroadcast.create!(:team_id=>training.team_id,
                                   :activity_id=>training.id)
  end 
end

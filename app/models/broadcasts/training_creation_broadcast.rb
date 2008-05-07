class TrainingCreationBroadcast < Broadcast
  belongs_to :training, :class_name=>"Training", :foreign_key=>"activity_id"
  belongs_to :team
  
  def activity
    training
  end
end

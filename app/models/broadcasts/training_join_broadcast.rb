class TrainingJoinBroadcast < Broadcast
  belongs_to :training, :class_name=>"Training", :foreign_key=>"activity_id"
  belongs_to :user
  belongs_to :team
end

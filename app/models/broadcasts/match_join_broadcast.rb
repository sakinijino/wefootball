class MatchJoinBroadcast < Broadcast
  belongs_to :match, :class_name=>"Match", :foreign_key=>"activity_id"
  belongs_to :user
  belongs_to :team
end

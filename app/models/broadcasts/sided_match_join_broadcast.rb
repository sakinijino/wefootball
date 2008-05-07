class SidedMatchJoinBroadcast < Broadcast
  belongs_to :sided_match, :class_name=>"SidedMatch", :foreign_key=>"activity_id"
  belongs_to :user 
  belongs_to :team  
end
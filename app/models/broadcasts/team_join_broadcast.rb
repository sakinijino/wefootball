class TeamJoinBroadcast < Broadcast
  belongs_to :user
  belongs_to :team
end

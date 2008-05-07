class PlayJoinBroadcast < Broadcast
  belongs_to :play, :class_name=>"Play", :foreign_key=>"activity_id"
  belongs_to :user
  
  def activity
    play
  end
end

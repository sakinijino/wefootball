class WatchJoinBroadcast < Broadcast
  belongs_to :watch, :class_name=>"Watch", :foreign_key=>"activity_id"
  belongs_to :user  
  
  def activity
    watch
  end
end

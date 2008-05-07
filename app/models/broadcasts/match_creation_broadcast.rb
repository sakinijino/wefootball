class MatchCreationBroadcast < Broadcast
  belongs_to :match, :class_name=>"Match", :foreign_key=>"activity_id"
  
  def activity
    match
  end
end

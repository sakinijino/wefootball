class Broadcast < ActiveRecord::Base
  
  def self.get_related_broadcasts(user,options={})
    friend_ids = user.friend_ids << user.id
    team_ids = user.teams.map{|item| item.id}
    if friend_ids.size > 0
      if team_ids.size > 0
        sql_condition = ["(#{(['user_id = ?']*friend_ids.size).join(' or ')}) or (#{(['team_id = ?']*team_ids.size).join(' or ')})", friend_ids, team_ids].flatten
      else
        sql_condition = ["(#{(['user_id = ?']*friend_ids.size).join(' or ')})", friend_ids].flatten
      end
    else
      if team_ids.size > 0
        sql_condition = ["(#{(['team_id = ?']*team_ids.size).join(' or ')})", team_ids].flatten
      else
        return []
      end      
    end
    bcs = Broadcast.find(:all,
                         {:conditions => sql_condition, :order => "created_at DESC"}.merge(options)
                         )
    bcs.reject do |item| 
      ((friend_ids.include?(item.user_id)) && (friend_ids.include?(item.friend_id)) && (item.user_id < item.friend_id))||
      ((item.class == MatchCreationBroadcast) && (team_ids.include?(item.match.host_team_id)) && (team_ids.include?(item.match.guest_team_id)) && (item.team_id == item.match.guest_team_id))
    end   
  end
end

class Broadcast < ActiveRecord::Base
  
  def self.get_related_broadcasts(user,options={})
    friend_ids = user.friend_ids << user.id
    team_ids = user.teams.map{|item| item.id}
    if friend_ids.size > 0
      if team_ids.size > 0
        sql_condition = ["user_id in (?) or team_id in (?)", friend_ids, team_ids]
      else
        sql_condition = ["user_id in (?)", friend_ids]
      end
    else
      if team_ids.size > 0
        sql_condition = ["team_id in (?)", team_ids]
      else
        return []
      end      
    end
    q = {:conditions => sql_condition, :order => "created_at DESC"}.merge(options)
    bcs = options.has_key?(:page) ? Broadcast.paginate(:all, q) : Broadcast.find(:all, q)
    bcs.reject do |item| 
      ((friend_ids.include?(item.user_id)) && (friend_ids.include?(item.friend_id)) && (item.user_id < item.friend_id))||
      ((item.class == MatchCreationBroadcast) && (team_ids.include?(item.match.host_team_id)) && (team_ids.include?(item.match.guest_team_id)) && (item.team_id == item.match.guest_team_id))
    end   
  end
end

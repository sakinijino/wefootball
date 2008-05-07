module BroadcastsHelper
  def broadcast_text(bc)
    case bc
    when FriendCreationBroadcast
    %(
     <div class="content">
      #{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}和#{link_to(h(bc.friend.nickname), user_view_path(bc.friend_id))}成为了朋友
     </div>
    )
    when MatchCreationBroadcast
    %(
     <div class="content">
      #{link_to(h(bc.match.host_team.shortname), team_view_path(bc.match.host_team_id))}和#{link_to(h(bc.match.guest_team.shortname), team_view_path(bc.match.guest_team_id))}约定进行一场#{link_to "比赛",match_path(bc.activity_id)}
     </div>
    )      
    when MatchJoinBroadcast
    %(
     <div class="content">
      #{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要代表#{link_to(h(bc.team.shortname), team_view_path(bc.team_id))}参加对阵#{(bc.team_id == bc.match.host_team_id) ? link_to(h(bc.match.guest_team.shortname), team_view_path(bc.match.guest_team_id)) : 
      link_to(h(bc.match.host_team.shortname), team_view_path(bc.match.host_team_id))}的#{link_to "比赛",match_path(bc.activity_id)}
     </div>
    )     
    when PlayJoinBroadcast
    %(
     <div class="content">
      #{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要去#{link_to "随便踢踢",play_path(bc.activity_id)}
     </div>
    )        
    when SidedMatchCreationBroadcast
    %(
     <div class="content">
      #{link_to(h(bc.team.shortname), team_view_path(bc.team_id))}新建了一场对阵#{h(bc.sided_match.guest_team_name)}的#{link_to "比赛",sided_match_path(bc.activity_id)}
     </div>
    )          
    when SidedMatchJoinBroadcast
    %(
     <div class="content">
      #{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要代表#{link_to(h(bc.team.shortname),
      team_view_path(bc.team_id))}参加对阵#{bc.sided_match.guest_team_name}的#{link_to "比赛",sided_match_path(bc.activity_id)}
     </div>
    )         
    when TeamJoinBroadcast
    %(
     <div class="content">
      #{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}加入了#{link_to(h(bc.team.shortname),
      team_view_path(bc.team_id))}
     </div>
    )        
    when TrainingCreationBroadcast
    %(
     <div class="content">
      #{link_to(h(bc.team.shortname),team_view_path(bc.team_id))}安排了一次#{link_to "训练",training_path(bc.activity_id)}
     </div>
    )        
    when TrainingJoinBroadcast
    %(
     <div class="content">
      #{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要参加#{link_to(h(bc.team.shortname),
      team_view_path(bc.team_id))}的#{link_to "训练",training_path(bc.activity_id)}
     </div>
    )       
    end
  end
end

module BroadcastsHelper
  def broadcast_text(bc)
    case bc
    when FriendCreationBroadcast
    %(
     <div class="broadcast">
       #{small_user_image_link bc.user, :class=>"icon l_icon"}
       <div class="content">
          #{small_user_image_link bc.friend, :class=>"icon r_icon"}
          <span class='qut'>#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}和#{
            link_to(h(bc.friend.nickname), user_view_path(bc.friend_id))
          }成为了朋友</span>
       </div>
     </div>
    )
    when MatchCreationBroadcast
    %(
     <div class="broadcast">
       #{small_team_image_link bc.match.host_team, :class=>"icon l_icon"}
       <div class="content">
          #{small_team_image_link bc.match.guest_team, :class=>"icon r_icon"}
          <span class='qut'>#{link_to(h(bc.match.host_team.shortname), team_view_path(bc.match.host_team_id))}和#{
            link_to(h(bc.match.guest_team.shortname), team_view_path(bc.match.guest_team_id))
          }约定进行一场#{link_to "比赛",match_path(bc.activity_id)}</span>
          <span class='dtal'>#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)}</span>
       </div>
     </div>
    )      
    when MatchJoinBroadcast
    %(
     <div class="broadcast">
       #{small_user_image_link bc.user, :class=>"icon l_icon"}
       <div class="content">
          #{small_team_image_link bc.team, :class=>"icon r_icon"}
          <span class='qut'>#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要代表#{
            link_to(h(bc.team.shortname), team_view_path(bc.team_id))
          }参加对阵#{
            (bc.team_id == bc.match.host_team_id) ? 
              link_to(h(bc.match.guest_team.shortname), team_view_path(bc.match.guest_team_id)) : 
              link_to(h(bc.match.host_team.shortname), team_view_path(bc.match.host_team_id))
          }的#{link_to "比赛",match_path(bc.activity_id)}</span>
          <span class='dtal'>#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)}</span>
       </div>
     </div>
    )     
    when PlayJoinBroadcast
    %(
     <div class="broadcast">
       #{small_user_image_link bc.user, :class=>"icon l_icon"}
       <div class="content">
          <span class='qut'>#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要去#{
            link_to "随便踢踢",play_path(bc.activity_id)
          }</span>
          <span class='dtal'>#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)}</span>
       </div>
     </div>
    )        
    when SidedMatchCreationBroadcast
    %(
     <div class="broadcast">
       #{small_team_image_link bc.team, :class=>"icon l_icon"}
       <div class="content">
          <span class='qut'>#{link_to(h(bc.team.shortname), team_view_path(bc.team_id))}新建了一场对阵#{
            h(bc.sided_match.guest_team_name)
          }的#{link_to "比赛",sided_match_path(bc.activity_id)}</span>
          <span class='dtal'>#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)}</span>
       </div>
     </div>
    )          
    when SidedMatchJoinBroadcast
    %(
     <div class="broadcast">
       #{small_user_image_link bc.user, :class=>"icon l_icon"}
       <div class="content">
          #{small_team_image_link bc.team, :class=>"icon r_icon"}
          <span class='qut'>#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要代表#{
            link_to(h(bc.team.shortname), team_view_path(bc.team_id))
          }参加对阵#{bc.sided_match.guest_team_name}的#{link_to "比赛",sided_match_path(bc.activity_id)}</span>
          <span class='dtal'>#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)}</span>
       </div>
     </div>
    )         
    when TeamJoinBroadcast
    %(
     <div class="broadcast">
       #{small_user_image_link bc.user, :class=>"icon l_icon"}
       <div class="content">
          #{small_team_image_link bc.team, :class=>"icon r_icon"}
          <span class='qut'>#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}加入了#{
            link_to(h(bc.team.shortname), team_view_path(bc.team_id))}</span>
       </div>
     </div>
    )        
    when TrainingCreationBroadcast
    %(
     <div class="broadcast">
       #{small_team_image_link bc.team, :class=>"icon l_icon"}
       <div class="content">
          <span class='qut'>#{link_to(h(bc.team.shortname),team_view_path(bc.team_id))}安排了一次#{
            link_to "训练",training_path(bc.activity_id)
          }</span>
          <span class='dtal'>#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)}</span>
       </div>
     </div>
    )        
    when TrainingJoinBroadcast
    %(
     <div class="broadcast">
       #{small_user_image_link bc.user, :class=>"icon l_icon"}
       <div class="content">
          #{small_team_image_link bc.team, :class=>"icon r_icon"}
          <span class='qut'>#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要参加#{
            link_to(h(bc.team.shortname), team_view_path(bc.team_id))}的#{link_to "训练",training_path(bc.activity_id)}</span>
          <span class='dtal'>#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)}</span>
       </div>
     </div>
    )       
    end
  end
end

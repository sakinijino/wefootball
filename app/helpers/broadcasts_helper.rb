module BroadcastsHelper
  def format_broadcast(bc)
    l_icon = nil
    r_icon = nil
    qut = nil
    dtal = nil
    case bc
    when FriendCreationBroadcast
      l_icon = user_image_link bc.user, :class=>"icon l_icon", :thumb => :small
      r_icon = user_image_link bc.friend, :class=>"icon r_icon", :thumb => :small
      qut = %(#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}和#{
          link_to(h(bc.friend.nickname), user_view_path(bc.friend_id))}成为了朋友)
          
    when MatchCreationBroadcast
      l_icon = team_image_link bc.match.host_team, :thumb=>:small, :class=>"icon l_icon"
      r_icon = team_image_link bc.match.guest_team, :thumb=>:small, :class=>"icon r_icon"
      qut = %(#{link_to(h(bc.match.host_team_name), team_view_path(bc.match.host_team_id))}和#{
            link_to(h(bc.match.guest_team_name), team_view_path(bc.match.guest_team_id))
          }约定进行一场#{link_to "比赛", bc.activity})
      dtal = %(#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)})
      
    when MatchJoinBroadcast
      l_icon = user_image_link bc.user, :class=>"icon l_icon", :thumb => :small
      r_icon = team_image_link bc.team, :thumb=>:small, :class=>"icon r_icon"
      qut = %(#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要代表#{
              link_to(h(bc.team.shortname), team_view_path(bc.team_id))
            }参加对阵#{
              (bc.team_id == bc.match.host_team_id) ? 
                link_to(h(bc.match.guest_team_name), team_view_path(bc.match.guest_team_id)) : 
                link_to(h(bc.match.host_team_name), team_view_path(bc.match.host_team_id))
            }的#{link_to "比赛", bc.activity})
      dtal = %(#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)})
      
    when PlayJoinBroadcast
      l_icon = user_image_link bc.user, :class=>"icon l_icon", :thumb => :small
      qut = %(#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要去#{
            link_to "随便踢踢", bc.activity})
      dtal = %(#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)})
      
    when WatchJoinBroadcast
      l_icon = user_image_link bc.user, :class=>"icon l_icon", :thumb => :small
      r_icon = %(<div class="match_icons r_icon">
        #{official_team_image_tag(bc.watch.official_match.host_team, :class=>'icon host_icon')}
        #{official_team_image_tag(bc.watch.official_match.guest_team, :class=>'icon guest_icon')}
      </div>
      )
      qut = %(#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要#{
            link_to "去看#{bc.watch.official_match.host_team_name}
            V.S. #{bc.watch.official_match.guest_team_name}",watch_path(bc.activity_id)
          })
      dtal = %(#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)})
    
    when MatchReviewRecommendationBroadcast
      host_team_icon, guest_team_icon = team_image_tags_of_match bc.match_review.match, {:class=>'icon host_icon'}, {:class=>'icon guest_icon'}
      l_icon = user_image_link bc.user, :class=>"icon l_icon", :thumb => :small
      r_icon = %(<div class="match_icons r_icon">
        #{host_team_icon}
        #{guest_team_icon}
      </div>
      )
      qut = %(#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}觉得#{
            link_to "#{bc.match_review.title}",match_review_path(bc.activity_id)
          }这篇球评写得不错)
      dtal = %(#{truncate(bc.match_review.content,70)})        
      
    when SidedMatchCreationBroadcast
      l_icon = team_image_link bc.team, :thumb=>:small, :class=>"icon l_icon"
      qut = %(#{link_to(h(bc.team.shortname), team_view_path(bc.team_id))}新建了一场对阵#{
            h(bc.sided_match.guest_team_name)
          }的#{link_to "比赛", bc.activity})
      dtal = %(#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)})

    when MatchReviewCreationBroadcast
      host_team_icon, guest_team_icon = team_image_tags_of_match bc.match_review.match, {:class=>'icon host_icon'}, {:class=>'icon guest_icon'}
      l_icon = user_image_link bc.user, :class=>"icon l_icon", :thumb => :small
      r_icon = %(<div class="match_icons r_icon">
        #{host_team_icon}
        #{guest_team_icon}
      </div>
      )
      qut = %(#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}写了一篇球评: #{
            link_to(h(bc.match_review.title), match_review_path(bc.activity_id))
          })
      dtal = %(#{truncate(bc.match_review.content,70)})      
      
    when SidedMatchJoinBroadcast
      l_icon = user_image_link bc.user, :class=>"icon l_icon", :thumb => :small
      r_icon = team_image_link bc.team, :thumb=>:small, :class=>"icon r_icon"
      qut = %(#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要代表#{
            link_to(h(bc.team.shortname), team_view_path(bc.team_id))
          }参加对阵#{bc.sided_match.guest_team_name}的#{link_to "比赛", bc.activity})
      dtal = %(#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)})
      
    when TeamJoinBroadcast
      l_icon = user_image_link bc.user, :class=>"icon l_icon", :thumb => :small
      r_icon = team_image_link bc.team, :thumb=>:small, :class=>"icon r_icon"
      qut = %(#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}加入了#{
            link_to(h(bc.team.shortname), team_view_path(bc.team_id))})
            
    when TrainingCreationBroadcast
      l_icon = team_image_link bc.team, :thumb=>:small, :class=>"icon l_icon"
      qut = %(#{link_to(h(bc.team.shortname),team_view_path(bc.team_id))}安排了一次#{
            link_to "训练", bc.activity})
      dtal = %(#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)})
      
    when TrainingJoinBroadcast
      l_icon = user_image_link bc.user, :class=>"icon l_icon", :thumb => :small
      r_icon = team_image_link bc.team, :thumb=>:small, :class=>"icon r_icon"
      qut = %(#{link_to(h(bc.user.nickname), user_view_path(bc.user_id))}要参加#{
            link_to(h(bc.team.shortname), team_view_path(bc.team_id))}的#{link_to "训练", bc.activity})
      dtal = %(#{bc.activity.start_time.strftime("%m月%d日 %H:%M")} - #{bc.activity.end_time.strftime("%H:%M")}, #{h(bc.activity.location)})
      
    end
    [l_icon, r_icon, qut, dtal]
  end
  
  def broadcast_text(bc)
    l_icon, r_icon, qut, dtal = format_broadcast bc
    %(
     <div class="broadcast">
       #{l_icon if !l_icon.blank?}
       <div class="content">
          #{r_icon if !r_icon.blank?}
          #{"<span class='qut'>#{qut}</span>" if !qut.blank?}
          #{"<span class='dtal'>#{dtal}</span>" if !dtal.blank?}
          <div class='cb'></div>
       </div>
     </div>
    ) 
  end
end

module MatchesHelper
   SITUATION_TEXTS = {1=>'不好说',2=>'狂胜', 3=>'完胜', 4=>'小胜', 5=>'势均力敌',
                      6=>'惜败', 7=>'完败', 8=>'被虐'}
  
  def situation_text(label)
   MatchesHelper::SITUATION_TEXTS[label]
  end
  
  def match_result_text(m)
    if (m.has_conflict)
      "结果有争议"
    else
      hg = !m.host_team_goal_by_host.blank? ? m.host_team_goal_by_host : m.host_team_goal_by_guest
      gg = !m.guest_team_goal_by_guest.blank? ? m.guest_team_goal_by_guest : m.guest_team_goal_by_host
      if (hg.blank? && gg.blank?)
        s = m.situation_by_host || m.situation_by_guest
        if s.nil?
          "比赛已结束"
        elsif s == 1
          situation_text s
        else
          %(#{link_to h(m.host_team.shortname), team_view_path(m.host_team)}
            #{situation_text s}
            #{link_to h(m.guest_team.shortname), team_view_path(m.guest_team)})
        end
      elsif hg.blank?
        "比赛已结束"
      elsif gg.blank?
        "比赛已结束"
      else
        "#{hg} : #{gg}"
      end
    end
  end
  
  def match_result_text_by_host(m)
    hg = m.host_team_goal_by_host
    gg = m.guest_team_goal_by_host
    s = m.situation_by_host
    if (!hg.blank? && !gg.blank?)
      "#{hg} : #{gg}"
    elsif (!hg.blank?)
      "主队进球数: #{hg}"
    elsif (!gg.blank?)
      "客队进球数: #{hg}"
    elsif (!s.blank?)
      "主队#{situation_text s}"
    end
  end
  
  def match_result_text_by_guest(m)
    hg = m.host_team_goal_by_guest
    gg = m.guest_team_goal_by_guest
    s = m.situation_by_guest
    if (!hg.blank? && !gg.blank?)
      "#{hg} : #{gg}"
    elsif (!hg.blank?)
      "主队进球数: #{hg}"
    elsif (!gg.blank?)
      "客队进球数: #{hg}"
    elsif (!s.blank?)
      "主队#{situation_text s}"
    end
  end
end
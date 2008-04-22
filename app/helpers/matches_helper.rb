module MatchesHelper
   SITUATION_TEXTS = {1=>'无所谓',2=>'狂胜', 3=>'完胜', 4=>'小胜', 5=>'势均力敌',
                      6=>'惜败', 7=>'完败', 8=>'被虐'}
  
  def situation_text(label)
   MatchesHelper::SITUATION_TEXTS[label]
  end
  
  def display_match_result(m)
    if (m.has_conflict)
      image_tag "match_result/conflict.gif"
    else
      hg = !m.host_team_goal_by_host.blank? ? m.host_team_goal_by_host : m.host_team_goal_by_guest
      gg = !m.guest_team_goal_by_guest.blank? ? m.guest_team_goal_by_guest : m.guest_team_goal_by_host
      if (hg.blank? && gg.blank?)
        s = m.situation_by_host || m.situation_by_guest
        if s.nil? || s == 1
          ""
        elsif s == 5
          image_tag "match_result/#{s}.gif"
        else
          %(#{image_tag "match_result/#{s}.gif"}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{image_tag "match_result/#{10-s}.gif"})
        end
      elsif hg.blank?
        "? : #{gg}"
      elsif gg.blank?
        "#{hg} : ?"
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
      "本队进#{hg}个球"
    elsif (!gg.blank?)
      "对方进#{gg}个球"
    elsif (!s.blank?)
      if s == 1 
        situation_text s
      elsif s == 5
        "比赛#{situation_text s}" 
      else
        "本队#{situation_text s}" 
      end
    end
  end
  
  def match_result_text_by_guest(m)
    hg = m.host_team_goal_by_guest
    gg = m.guest_team_goal_by_guest
    s = m.situation_by_guest
    if (!hg.blank? && !gg.blank?)
      "#{hg} : #{gg}"
    elsif (!hg.blank?)
      "对方进#{hg}个球"
    elsif (!gg.blank?)
      "本队进#{gg}个球"
    elsif (!s.blank?)
      if s == 1 
        situation_text s
      elsif s == 5
        "比赛#{situation_text s}" 
      else
        "本队#{situation_text 10-s}" 
      end
    end
  end
end
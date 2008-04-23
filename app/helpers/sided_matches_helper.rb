module SidedMatchesHelper
  MATCH_TYPE_TEXTS = {1=>'随便玩玩', 2=>'真刀真枪'}
  WIN_RULE_TEXTS = {1=>'直接结束', 2=>'加时赛点球', 3=> '直接点球'}
     
  def match_type_text(label)
    SidedMatchesHelper::MATCH_TYPE_TEXTS[label]
  end
  
  def win_rule_text(label)
    SidedMatchesHelper::WIN_RULE_TEXTS[label]
  end
  
  def sided_match_result_text(m)
    hg = m.host_team_goal
    gg = m.guest_team_goal
    s = m.situation
    if (hg.blank? && gg.blank?)
      if s.nil?
        "尚未填写赛果"
      elsif s == 1 || s == 5
        situation_text s
      else
        "我队#{situation_text s}"
      end
    elsif hg.blank?
      "#{m.guest_team_name}进了#{gg}个球"
    elsif gg.blank?
      "我队进了#{hg}个球"
    else
      "#{hg} : #{gg}"
    end
  end
    
  def display_sided_match_result(m)
    hg = m.host_team_goal
    gg = m.guest_team_goal
    s = m.situation
    if (hg.blank? && gg.blank?)
      if !s.nil? && s != 1
        image_tag "match_result/#{s}.gif", :title=>""
      end
    elsif hg.blank?
      "? : #{gg}"
    elsif gg.blank?
      "#{hg} : ?"
    elsif !hg.blank? && !gg.blank?
      "#{hg} : #{gg}"
    end
  end
end

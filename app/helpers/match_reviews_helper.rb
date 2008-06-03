module MatchReviewsHelper
  def team_icons_of_match(m)
    if m.class == OfficialMatch
      host_team_icon = official_team_icon(m.host_team)
      guest_team_icon = official_team_icon(m.guest_team)
    elsif m.class == Match
      host_team_icon = team_icon(m.host_team)
      guest_team_icon = team_icon(m.guest_team)
    elsif m.class == SidedMatch
      host_team_icon = team_icon(m.host_team)
      guest_team_icon = team_icon(Team.new(:shortname => m.guest_team_name))
    end
    
    [host_team_icon, guest_team_icon]
  end
  
  def team_image_links_of_match(m, host_option={}, guest_option={}, host_link_option={}, guest_link_option={})
    if m.class == OfficialMatch
      host_team_icon = official_team_image_tag(m.host_team, host_option.merge(host_link_option))
      guest_team_icon = official_team_image_tag(m.guest_team, guest_option.merge(guest_link_option))
    elsif m.class == Match
      host_team_icon = team_image_link(m.host_team, {:thumb => :small}.merge(host_option), host_link_option)
      guest_team_icon = team_image_link(m.guest_team, {:thumb => :small}.merge(guest_option), guest_link_option)
    elsif m.class == SidedMatch
      host_team_icon = team_image_link(m.host_team, {:thumb => :small}.merge(host_option), host_link_option)
      guest_team_icon = team_image_tag(Team.new(:shortname => m.guest_team_name), {:thumb => :small}.merge(guest_option).merge(guest_link_option))
    end
    
    [host_team_icon, guest_team_icon]
  end
end

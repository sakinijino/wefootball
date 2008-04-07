module TeamsHelper
  def team_image_tag(team, options={})
    image_tag(team.image, {:width=>TeamImage::WIDTH, :height=>TeamImage::HEIGHT, :title=>h(team.shortname)}.merge(options))
  end
  
  def team_image_link(team, options={})
    link_to team_image_tag(team, options), team_view_path(team.id)
  end
  
  def small_team_image_tag(team, options={})
    image_tag(team.image(:small), {:width=>TeamImage::SMALL_WIDTH, :height=>TeamImage::SMALL_HEIGHT, 
        :class=>"icon", :title=>team.shortname}.merge(options))
  end
  
  def small_team_image_link(team, options={})
    link_to small_team_image_tag(team, options), team_view_path(team.id)
  end
  
  def team_icon(team)
    content = ''
    case team
    when Team
      content << %(
      <div class="icon">
        #{small_team_image_link team}
        <span>#{link_to h(team.shortname), team_view_path(team.id)}</span>
      </div>)
    else
      if team.respond_to?(:each)
        team.each {|u| content << team_icon(u)}
      end
    end   
    content
  end
end

module OfficalTeamsHelper
  def offical_team_image_tag(offical_team, options={})
    thumb = options[:thumb]
    options.delete :thumb
    image_tag(offical_team.image, {:width=>OfficalTeamImage::WIDTH, :height=>OfficalTeamImage::HEIGHT, 
        :class=>"icon", :title=>h(offical_team.name)}.merge(options))
  end
  
  def offical_team_icon(offical_team)
    content = ''
    case offical_team
    when OfficalTeam
      content << %(
      <div class="icon">
        #{offical_team_image_tag(offical_team)}
        <span>#{h(offical_team.name)}</span>
      </div>)
    else
      if offical_team.respond_to?(:each)
        offical_team.each {|t| content << offical_team_icon(t)}
      end
    end
    content
  end
end

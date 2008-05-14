module OfficalTeamsHelper
  def offical_team_image_tag(offical_team, options={})
    thumb = options[:thumb]
    options.delete :thumb
    image_tag(offical_team.image, {:width=>OfficalTeamImage::WIDTH, :height=>OfficalTeamImage::HEIGHT, 
        :class=>"icon", :title=>h(offical_team.name)}.merge(options))
  end
  
  def offical_team_icon(offical_team, edit_link=false)
    content = ''
    case offical_team
    when OfficalTeam
      content << %(
      <div class="icon">
        #{edit_link ? (link_to offical_team_image_tag(offical_team), edit_offical_team_path(offical_team.id)) : offical_team_image_tag(offical_team)}
        <span>#{edit_link ? (link_to h(offical_team.name), edit_offical_team_path(offical_team.id)) : h(offical_team.name)}</span>
      </div>)
    else
      if offical_team.respond_to?(:each)
        offical_team.each {|t| content << offical_team_icon(t, edit_link)}
      end
    end
    content
  end
end

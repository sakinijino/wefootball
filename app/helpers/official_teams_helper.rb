module OfficialTeamsHelper
  def official_team_image_tag(official_team, options={})
    thumb = options[:thumb]
    options.delete :thumb
    image_tag(official_team.image, {:width=>OfficialTeamImage::WIDTH, :height=>OfficialTeamImage::HEIGHT, 
        :class=>"icon", :title=>h(official_team.name)}.merge(options))
  end
  
  def official_team_icon(official_team)
    content = ''
    case official_team
    when OfficialTeam
      content << %(
      <div class="icon">
        #{official_team_image_tag(official_team)}
        <span>#{h(official_team.name)}</span>
      </div>)
    else
      if official_team.respond_to?(:each)
        official_team.each {|t| content << official_team_icon(t)}
      end
    end
    content
  end
end

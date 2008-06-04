module OfficialTeamsHelper
  def official_team_image_tag(official_team, options={})
    thumb = options[:thumb]
    options.delete :thumb
    case thumb
    when :small
      image_tag(official_team.image(:small), {:width=>OfficialTeamImage::SMALL_WIDTH, :height=>OfficialTeamImage::SMALL_HEIGHT, 
        :class=>"icon", :title=>official_team.name}.merge(options))
    else
      image_tag(official_team.image, {:width=>OfficialTeamImage::WIDTH, :height=>OfficialTeamImage::HEIGHT, 
        :title=>h(official_team.name)}.merge(options))
    end
  end
  
  def official_team_image_link(official_team, options={}, link_options={})
    link_to official_team_image_tag(official_team, options), official_team, link_options
  end
  
  def official_team_icon(official_team)
    content = ''
    case official_team
    when OfficialTeam
      content << %(
      <div class="icon ot_icon">
        #{official_team_image_link(official_team, :thumb=>:small)}
        <span>#{link_to(h(official_team.name), official_team)}</span>
      </div>)
    else
      if official_team.respond_to?(:each)
        official_team.each {|t| content << official_team_icon(t)}
      end
    end
    content
  end
end

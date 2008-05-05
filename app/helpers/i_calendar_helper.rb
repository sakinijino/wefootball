module ICalendarHelper
  def icalendar_path(link_text, entity, options={})
    case entity
    when User
      link_to link_text, user_icalendar_path(entity), options
    when Team
      link_to link_text, team_icalendar_path(entity), options
    else
      link_text
    end
  end
end

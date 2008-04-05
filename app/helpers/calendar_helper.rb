module CalendarHelper
  WDAY_TEXT = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
  def wday_text(wday)
    WDAY_TEXT[wday]
  end
  
  def month_calendar_link(link_text, date, entity, options={})
    case entity
    when User
      link_to link_text, user_month_calendar_url(entity.id, date.year, date.month), options
    when Team
      link_to link_text, team_month_calendar_url(entity.id, date.year, date.month), options
    else
      link_text
    end
  end
  
  def day_calendar_link(link_text, date, entity, options={})
    case entity
    when User
      link_to link_text, user_day_calendar_url(entity.id, date.year, date.month, date.day), options
    when Team
      link_to link_text, team_day_calendar_url(entity.id, date.year, date.month, date.day), options
    else
      link_text
    end
  end
end

module CalendarHelper
  WDAY_TEXT = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
  def wday_text(wday)
    WDAY_TEXT[wday]
  end
  
  def activity_icon(act)
    link_to image_tag(act.icon, :title=> act.img_title), act
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
  
  def date_div_link(date, entity)
    content = ''
    content << %(
    <div class="date">
      <div class="day">
         #{month_calendar_link(date.strftime('%m'), date, entity)}.#{day_calendar_link(date.strftime('%d'), date, entity)}
      </div>
      <div class="week">#{wday_text date.wday}</div>
    </div>)
    content
  end
end

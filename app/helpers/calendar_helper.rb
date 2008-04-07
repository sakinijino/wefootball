module CalendarHelper
  WDAY_TEXT = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
  def wday_text(wday)
    WDAY_TEXT[wday]
  end
  
  def match_icon_link(m)
    case m
    when Match
      title = "#{m.start_time.strftime("%m月%d日")} #{m.start_time.strftime("%H:%M")}-#{m.end_time.strftime("%H:%M")}\n在#{m.location}比赛"
    else
      title = ""
    end
    link_to image_tag('match_icon.gif', :title=> title), match_view_path(m)
  end
  
  def play_icon_link(t)
    case t
    when Play
      title = "#{t.start_time.strftime("%m月%d日")} #{t.start_time.strftime("%H:%M")}-#{t.end_time.strftime("%H:%M")}\n去#{t.location}随便踢踢"
    else
      title = ""
    end
    link_to image_tag('play_icon.gif', :title=> title), play_path(t)
  end
  
  def training_icon_link(t)
    case t
    when Training
      title = "#{t.start_time.strftime("%m月%d日")} #{t.start_time.strftime("%H:%M")}-#{t.end_time.strftime("%H:%M")}\n在#{t.location}训练"
    else
      title = ""
    end
    link_to image_tag('training_icon.gif', :title=> title), training_path(t)
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

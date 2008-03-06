module ActivityCalendar
  def recent(limit=nil, timeline=Time.now)
    find :all, :conditions => ['start_time > ?', timeline], 
      :order=>'start_time', 
      :limit=>limit
  end
  
  def in_a_month(date = Time.today)
    date = date.to_datetime.at_midnight
    start_time = date.at_beginning_of_month
    end_time = start_time.next_month
    find_in_duration(start_time, end_time)
  end
  
  def in_a_week(date = Time.today)
    date = date.to_datetime.at_midnight
    start_time = date.monday
    end_time = start_time.next_week
    find_in_duration(start_time, end_time)
  end
  
  def in_a_day(date = Time.today)
    date = date.to_datetime.at_midnight
    start_time = date.at_midnight
    end_time = start_time.tomorrow
    find_in_duration(start_time, end_time)
  end
  
  private
  def find_in_duration(start, endd)
    find :all, 
      :conditions => ['start_time >= ? and start_time < ?', start, endd], 
      :order=>'start_time'
  end
end

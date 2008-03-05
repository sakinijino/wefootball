module ActivityCalendar
  def recent(limit=nil, timeline=Time.now)
    find :all, :conditions => ['start_time > ?', timeline], 
      :order=>'start_time', 
      :limit=>limit
  end
  
  def in_a_month(date = Date.today)
    start_time = date.at_beginning_of_month
    end_time = start_time.next_month.ago(1)
    find_in_duration(start_time, end_time)
  end
  
  def in_a_week(date = Date.today)
    start_time = date.monday
    end_time = start_time.next_week.ago(1)
    find_in_duration(start_time, end_time)
  end
  
  def in_a_day(date = Date.today)
    start_time = date.at_midnight
    end_time = start_time.tomorrow.ago(1)
    find_in_duration(start_time, end_time)
  end
  
  private
  def find_in_duration(start, endd)
    find :all, 
      :conditions => ['start_time > ? and start_time < ?', start, endd], 
      :order=>'start_time'
  end
end

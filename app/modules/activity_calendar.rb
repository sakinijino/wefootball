module ActivityCalendar
  def recent(limit=nil, timeline=Time.now)
    find :all, :conditions => ['start_time > ?', timeline], 
      :order=>'start_time', 
      :limit=>limit
  end
  
  def in_a_duration(start_time, end_time)
    find_in_duration(start_time, end_time)
  end
  
  def in_a_month(date = Time.today)
    date = date.to_datetime.at_midnight
    start_time = date.at_beginning_of_month
    end_time = start_time.next_month
    find_in_duration(start_time, end_time)
  end
  
  def in_an_extended_month(date = Time.today)
    date = date.to_datetime.at_midnight
    start_time = date.at_beginning_of_month
    end_time = start_time.next_month
    start_time = start_time.monday.yesterday if start_time.wday>0
    end_time = end_time.monday.next_week.yesterday.yesterday if end_time.wday<6
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
  
  def in_later_hours(hours = 24, date = Time.now)
    start_time = date
    end_time = start_time.since(hours*3600)
    find_in_duration(start_time, end_time)
  end
  
  private
  def find_in_duration(start, endd)
#    if @reflection.klass == Match
#      find :all, 
#        :conditions => ['start_time > ? and start_time < ?', start.ago(60*@target.full_match_length), endd], 
#        :order=>'start_time'      
#    else
      find :all, 
        :conditions => ['end_time > ? and start_time < ?', start, endd], 
        :order=>'start_time'
    end
#  end
end

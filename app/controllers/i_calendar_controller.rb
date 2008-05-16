require 'icalendar'

class ICalendarController < ApplicationController
  DISPLAY_DAYS = 28
  
  def user
    @user = User.find(params[:id], :conditions=>"activated_at is not null")    
    @start_time = 14.days.ago.at_midnight
    et = @start_time.since(3600*24*DISPLAY_DAYS)
    @calendar_activities = 
      (@user.trainings.in_a_duration(@start_time, et) + 
        @user.matches.in_a_duration(@start_time, et)+
        @user.sided_matches.in_a_duration(@start_time, et)+
        @user.plays.in_a_duration(@start_time, et))
    headers['Content-Type'] = 'text/calendar'
    headers['Cache-Control'] = 'no-cache'
    render :inline => generate_calendar("#{@user.nickname}近期的活动", @calendar_activities).to_ical
  end
  
  def team
    @team = Team.find(params[:id])
    @start_time = 14.days.ago.at_midnight
    et = @start_time.since(3600*24*DISPLAY_DAYS)
    @calendar_activities = 
      (@team.trainings.in_a_duration(@start_time, et) +
       @team.sided_matches.in_a_duration(@start_time, et) +
       @team.match_calendar_proxy.in_a_duration(@start_time, et))
    headers['Content-Type'] = 'text/calendar'
    headers['Cache-Control'] = 'no-cache'
    render :inline => generate_calendar("#{@team.shortname}近期的活动", @calendar_activities).to_ical
  end
  
  protected
  def generate_calendar(name, activities)
    cal = Icalendar::Calendar.new
    cal.prodid = "WeFootball-iCalendar"
    cal.custom_property("X-WR-CALNAME", name)
    cal.custom_property("X-WR-TIMEZONE", "Asia/Shanghai")
    activities.each do |act|
      event = Icalendar::Event.new
      event.dtstart act.start_time.strftime("%Y%m%dT%H%M%S")
      event.dtend act.end_time.strftime("%Y%m%dT%H%M%S")
      event.location act.location
      event.summary(case act
      when Play
        "随便踢踢"
      when Training
        "#{act.team.shortname}训练"
      when SidedMatch
        "#{act.host_team.shortname} V.S. #{act.guest_team_name}的比赛"
      when Match
        "#{act.host_team.shortname} V.S. #{act.guest_team.shortname}的比赛"
      end)
      
      event.description(case act
      when Play
        play_url act
      when Training
        %Q(#{act.summary.gsub(/\r\n/, "\n")}\n\n#{training_url act})
      when SidedMatch
        %Q(#{act.description.gsub(/\r\n/, "\n")}\n\n#{sided_match_url act})
      when Match
        %Q(#{act.description.gsub(/\r\n/, "\n")}\n\n#{match_url act})
      end)
      event.url(case act
      when Play
        play_url act
      when Training
        training_url act
      when SidedMatch
        sided_match_url act
      when Match
        match_url act
      end)
      event.uid "www.wefootball.org-#{act.class}-#{act.id}"
      cal.add event
    end
    cal
  end
end

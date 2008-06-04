class CalendarController < ApplicationController

  def show_a_day
    @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    if (params[:user_id])
      @user = User.find_by_id(params[:user_id], :conditions=>"activated_at is not null")
      @activities = 
        (@user.trainings.in_a_day(@date) +
         @user.matches.in_a_day(@date) +
         @user.sided_matches.in_a_day(@date) +
         @user.plays.in_a_day(@date) + 
         @user.watches.in_a_day(@date)).group_by{|t| t.start_time.strftime("%Y-%m-%d")}
      @title = "#{@user.nickname}, #{@date.month}月#{@date.day}日的活动"
      render :layout => 'user_layout'
    elsif (params[:team_id])
      @team = Team.find(params[:team_id])
      @activities = 
        (@team.trainings.in_a_day(@date) + 
         @team.sided_matches.in_a_day(@date)+
          @team.match_calendar_proxy.in_a_day(@date)).group_by{|t| t.start_time.strftime("%Y-%m-%d")}
      @title = "#{@team.shortname}, #{@date.month}月#{@date.day}日的活动"
      render :layout => 'team_layout'
    end
  end

  def show_a_month
    @date = Date.new(params[:year].to_i, params[:month].to_i)
    if (params[:user_id])
      @user = User.find(params[:user_id], :conditions=>"activated_at is not null")
      @calendar_activities_hash = 
        (@user.trainings.in_an_extended_month(@date)+
         @user.matches.in_an_extended_month(@date) +
         @user.sided_matches.in_an_extended_month(@date) +
         @user.plays.in_an_extended_month(@date) +
         @user.watches.in_an_extended_month(@date)).group_by{|t| t.start_time.strftime("%Y-%m-%d")}
      @title = "#{@user.nickname}, #{@date.month}月的活动"
      render :layout => 'user_layout'
    elsif (params[:team_id])
      @team = Team.find(params[:team_id])
      @calendar_activities_hash = 
        (@team.trainings.in_an_extended_month(@date)+
         @team.sided_matches.in_an_extended_month(@date)+
          @team.match_calendar_proxy.in_an_extended_month(@date)).group_by{|m| m.start_time.strftime("%Y-%m-%d")}      
      @title = "#{@team.shortname}, #{@date.month}月的活动"
      render :layout => 'team_layout'
    elsif (params[:official_team_id])
      @official_team = OfficialTeam.find(params[:official_team_id])
      date = DateTime.now.at_midnight
      start_time = date.at_beginning_of_month
      end_time = start_time.next_month
      start_time = start_time.monday.yesterday if start_time.wday>0
      end_time = end_time.monday.next_week.yesterday.yesterday if end_time.wday<6
      @calendar_activities_hash = OfficialMatch.find(:all, 
        :conditions =>
          ['(end_time > ? and start_time < ?) and (host_official_team_id = ? or guest_official_team_id = ?)', 
          start_time, end_time, @official_team.id, @official_team.id]).group_by{|m| m.start_time.strftime("%Y-%m-%d")}      
      @title = "#{@official_team.name}, #{@date.month}月的比赛"
      render :layout => 'official_team_layout'
    end
  end
end

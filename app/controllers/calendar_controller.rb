class CalendarController < ApplicationController

  def show_a_day
    if (params[:user_id])
      @user = User.find(params[:user_id])
      @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      @trainings = @user.trainings.in_a_day(@date)
      @matches = @user.matches.in_a_day(@date)        
      @title = "#{@user.nickname}, #{@date.month}月#{@date.day}日的安排"
      render :layout => 'user_layout'
    elsif (params[:team_id])
      @team = Team.find(params[:team_id])
      @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      @trainings = @team.trainings.in_a_day(@date)
      @matches = @team.matches.in_a_day(@date)      
      @title = "#{@team.shortname}, #{@date.month}月#{@date.day}日的安排"
      @team_display = false;
      render :layout => 'team_layout'
    end
  end

  def show_a_month
    if (params[:user_id])
      @user = User.find(params[:user_id])
      @date = Date.new(params[:year].to_i, params[:month].to_i)
      @calendar_trainings_hash = @user.trainings.in_an_extended_month(@date).group_by{|t| t.start_time.strftime("%Y-%m-%d")}
      @title = "#{@user.nickname}, #{@date.month}月的安排"
      render :layout => 'user_layout'
    elsif (params[:team_id])
      @team = Team.find(params[:team_id])
      @date = Date.new(params[:year].to_i, params[:month].to_i)
      @calendar_trainings_hash = @team.trainings.in_an_extended_month(@date).group_by{|t| t.start_time.strftime("%Y-%m-%d")}
      @calendar_matches_hash = @team.matches.in_an_extended_month(@date).group_by{|m| m.start_time.strftime("%Y-%m-%d")}      
      @title = "#{@team.shortname}, #{@date.month}月的安排"
      render :layout => 'team_layout'
    end
  end
end

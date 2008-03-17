class UserViewsController < ApplicationController
  layout "user_layout"
  
  FRIEND_LIST_LENGTH = 9
  TEAM_LIST_LENGTH = 9
  TRAINING_LIST_LENGTH = 1
  
  def show
    @user = User.find(params[:id], :include=>[:positions])
    @friends = @user.friends(FRIEND_LIST_LENGTH)
    @teams = @user.teams.find(:all, :limit => TEAM_LIST_LENGTH)
    @trainings = @user.trainings.recent(TRAINING_LIST_LENGTH, Time.today)
    @title = "#{@user.nickname}的主页"
    @calendar_trainings_hash = @user.trainings.in_a_duration(Time.today, Time.today.since(3600*24*18)).group_by{|t| t.start_time.strftime("%Y-%m-%d")}
  end
end

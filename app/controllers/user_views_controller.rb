class UserViewsController < ApplicationController
  layout "user_layout"
  
  FRIEND_LIST_LENGTH = 5
  TEAM_LIST_LENGTH = 5
  TRAINING_LIST_LENGTH = 5
  
  def show
    @user = User.find(params[:id], :include=>[:positions, :user_image])
    @friends = @user.friends(FRIEND_LIST_LENGTH)
    @teams = @user.teams.find(:all, :limit => TEAM_LIST_LENGTH)
    @trainings = @user.trainings.recent(TRAINING_LIST_LENGTH, Time.today)
    @title = "#{@user.nickname}的主页"
    @calendar_trainings_hash = @user.trainings.in_a_month.group_by{|t| t.start_time.strftime("%Y-%m-%d")}
  end
end

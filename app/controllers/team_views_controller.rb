class TeamViewsController < ApplicationController
  layout "team_layout"
  
  TRAINING_LIST_LENGTH = 5
  USER_LIST_LENGTH = 10
  
  def show
    @team = Team.find(params[:id], :include=>[:team_image])
    @user_team = UserTeam.find_by_user_id_and_team_id(current_user, @team)
    @trainings = @team.trainings.recent(TRAINING_LIST_LENGTH, Time.today)
    @users = @team.users.find(:all, :limit => USER_LIST_LENGTH)
    @posts = @team.posts.find(:all, :limit=>10)
    @title = "#{@team.shortname}的首页"
    @calendar_trainings_hash = @team.trainings.in_a_month.group_by{|t| t.start_time.strftime("%Y-%m-%d")}
  end
end

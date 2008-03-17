class TeamViewsController < ApplicationController
  layout "team_layout"
  
  TRAINING_LIST_LENGTH = 1
  USER_LIST_LENGTH = 9
  POSTS_LENGTH = 10
  MATCH_LIST_LENGTH = 5
  
  def show
    @team = Team.find(params[:id])
    @user_team = UserTeam.find_by_user_id_and_team_id(current_user, @team)
    @trainings = @team.trainings.recent(TRAINING_LIST_LENGTH, Time.today)
    @matches = @team.matches.recent(MATCH_LIST_LENGTH, Time.today)
    @users = @team.users.find(:all, :limit => USER_LIST_LENGTH)
    @posts = @team.posts.find(:all, :limit=> POSTS_LENGTH)
    @title = "#{@team.shortname}的首页"
    @calendar_trainings_hash = @team.trainings.in_a_duration(Time.today, Time.today.since(3600*24*18)).group_by{|t| t.start_time.strftime("%Y-%m-%d")}
  end
end

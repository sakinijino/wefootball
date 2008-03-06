class TeamViewsController < ApplicationController
  TRAINING_LIST_LENGTH = 5
  USER_LIST_LENGTH = 10
  
  def show
    store_location
    @team = Team.find(params[:id], :include=>[:team_image])
    @user_team = UserTeam.find_by_user_id_and_team_id(current_user, @team)
    @trainings = @team.trainings.recent(TRAINING_LIST_LENGTH, Time.today)
    @users = @team.users.find(:all, :limit => USER_LIST_LENGTH)
    @posts = @team.posts.find(:all, :limit=>10)
  end
end

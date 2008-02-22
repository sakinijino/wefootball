class TeamViewsController < ApplicationController
  TRAINING_LIST_LENGTH = 5
  USER_LIST_LENGTH = 10
  
  def show
    store_location
    @team = Team.find(params[:id], :include=>[:team_image])
    @trainings = @team.trainings.recent(TRAINING_LIST_LENGTH, Date.today)
    @users = @team.users.limit(USER_LIST_LENGTH)
  end
end

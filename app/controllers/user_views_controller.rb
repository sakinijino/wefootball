class UserViewsController < ApplicationController
  FRIEND_LIST_LENGTH = 5
  TEAM_LIST_LENGTH = 5
  TRAINING_LIST_LENGTH = 5
  
  def show
    @user = User.find(params[:id], :include=>[:positions, :user_image])
    @friends = @user.friends(FRIEND_LIST_LENGTH)
    @teams = @user.teams.limit(TEAM_LIST_LENGTH)
    @trainings = @user.trainings.recent(TRAINING_LIST_LENGTH, Date.today)
  end
end

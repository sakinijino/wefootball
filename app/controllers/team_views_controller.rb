class TeamViewsController < ApplicationController
  layout "team_layout"
  
  TRAINING_LIST_LENGTH = 1
  USER_LIST_LENGTH = 9
  POSTS_LENGTH = 10
  MATCH_LIST_LENGTH = 5
  
  def show
    @team = Team.find(params[:id])
    
    @trainings = @team.trainings.recent(TRAINING_LIST_LENGTH, Time.today)
    @matches = @team.matches.recent(MATCH_LIST_LENGTH, Time.today)
    @users = @team.users.find(:all, :limit => USER_LIST_LENGTH)
    @posts = @team.posts.find(:all, :limit=> POSTS_LENGTH)
    @calendar_trainings_hash = @team.trainings.in_a_duration(Time.today, Time.today.since(3600*24*18)).group_by{|t| t.start_time.strftime("%Y-%m-%d")}
    
    @user_team = logged_in? ? UserTeam.find_by_user_id_and_team_id(current_user, @team) : nil
    @team_join_request = logged_in? ? TeamJoinRequest.find_by_user_id_and_team_id_and_is_invitation(current_user, @team, false) : nil
    @team_join_invitation = logged_in? ? TeamJoinRequest.find_by_user_id_and_team_id_and_is_invitation(current_user, @team, true) : nil
    @can_request = logged_in? && @user_team == nil && @team_join_request == nil && @team_join_invitation==nil
    @can_quit = logged_in?  && @user_team != nil && @user_team.user_id == self.current_user.id && @user_team.can_destroy_by?(current_user)
    
    @title = "#{@team.shortname}的首页"
  end
end

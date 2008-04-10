class UserViewsController < ApplicationController
  layout "user_layout"
  
  FRIEND_LIST_LENGTH = 9
  TEAM_LIST_LENGTH = 9
  TRAINING_LIST_LENGTH = 1
  MATCHES_LIST_LENGTH = 1
  PLAYS_LIST_LENGTH = 1
  DISPLAY_DAYS = 13
  
  def show
    @user = User.find(params[:id], :include=>[:positions])
    @friends = @user.friends(FRIEND_LIST_LENGTH)
    @teams = @user.teams.find(:all, :limit => TEAM_LIST_LENGTH)
    
    activities = []
    tmp = @user.trainings.recent(TRAINING_LIST_LENGTH)
    activities << tmp[0] if tmp.length > 0
    tmp = @user.matches.recent(MATCHES_LIST_LENGTH)
    activities << tmp[0] if tmp.length > 0
    tmp = @user.plays.recent(PLAYS_LIST_LENGTH)
    activities << tmp[0] if tmp.length > 0   
    @recent_activity = activities.length > 0 ? (activities.sort_by{|act| act.start_time})[0] : nil
    
    st = Time.today
    et = Time.today.since(3600*24*DISPLAY_DAYS)
    @calendar_activities_hash = 
      (@user.trainings.in_a_duration(st, et) + 
      @user.matches.in_a_duration(st, et)+
      @user.plays.in_a_duration(st, et)).group_by {|t| t.start_time.strftime("%Y-%m-%d")}
    
    @firend_request = logged_in? ? FriendInvitation.find_by_applier_id_and_host_id(current_user, @user.id) : nil
    @firend_invitation = logged_in? ? FriendInvitation.find_by_applier_id_and_host_id(@user.id, current_user) : nil
    @are_friends = logged_in? && @user.is_my_friend?(current_user)    
    @can_send_invitation = (logged_in? && self.current_user.id != @user.id && @firend_invitation==nil && @firend_request==nil && !@are_friends)
    
    @user_invitation_count = 0
    @team_invitation_count = 0
    if logged_in? && @user.id == self.current_user.id
      @user_invitation_count = FriendInvitation.count(:conditions => ["host_id = ?", current_user])
      @team_invitation_count = TeamJoinRequest.count(:conditions => ["user_id = ? and is_invitation = ?", current_user, true])
    end
    
    @title = "#{@user.nickname}的主页"
  end
end

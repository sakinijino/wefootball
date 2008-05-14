class UserViewsController < ApplicationController
  layout "user_layout"
  
  FRIEND_LIST_LENGTH = 9
  TEAM_LIST_LENGTH = 9
  TRAINING_LIST_LENGTH = 1
  MATCH_LIST_LENGTH = 1
  SIDED_MATCH_LIST_LENGTH = 1
  PLAY_LIST_LENGTH = 1
  DISPLAY_DAYS = 14
  POST_LIST_LENGTH = 10
  BROADCAST_LIST_LENGTH = 10
  
  def show
    @user = User.find(params[:id], :include=>[:positions], :conditions=>"activated_at is not null")
    @friends = @user.friends(FRIEND_LIST_LENGTH + 1)
    @teams = @user.teams.find(:all, :limit => TEAM_LIST_LENGTH+1)
    
    activities = []
    tmp = @user.trainings.recent(TRAINING_LIST_LENGTH)
    activities << tmp[0] if tmp.length > 0
    tmp = @user.matches.recent(MATCH_LIST_LENGTH)
    activities << tmp[0] if tmp.length > 0
    tmp = @user.sided_matches.recent(SIDED_MATCH_LIST_LENGTH)
    activities << tmp[0] if tmp.length > 0
    tmp = @user.plays.recent(PLAY_LIST_LENGTH)
    activities << tmp[0] if tmp.length > 0
    @recent_activity = activities.length > 0 ? (activities.sort_by{|act| act.start_time})[0] : nil
    
    @start_time = 3.days.ago.at_midnight
    et = @start_time.since(3600*24*DISPLAY_DAYS)
    @calendar_activities_hash = 
      (@user.trainings.in_a_duration(@start_time, et) + 
      @user.matches.in_a_duration(@start_time, et)+
      @user.sided_matches.in_a_duration(@start_time, et)+
      @user.plays.in_a_duration(@start_time, et)).group_by {|t| t.start_time.strftime("%Y-%m-%d")}
    
    @firend_request = logged_in? ? FriendInvitation.find_by_applier_id_and_host_id(current_user, @user.id) : nil
    @firend_invitation = logged_in? ? FriendInvitation.find_by_applier_id_and_host_id(@user.id, current_user) : nil
    @are_friends = logged_in? && @user.is_my_friend?(current_user)    
    @can_send_invitation = (logged_in? && self.current_user.id != @user.id && @firend_invitation==nil && @firend_request==nil && !@are_friends)
    
    @user_invitation_count = 0
    @team_invitation_count = 0
    @team_join_requests_count = 0
    @match_invitations_count = 0
    if logged_in? && @user.id == self.current_user.id
      @user_invitation_count = current_user.friend_invitations_count
      @team_invitation_count = current_user.team_join_invitations_count
      @team_join_requests_count = current_user.admin_teams_count_sum(:team_join_requests_count)
      @match_invitations_count = current_user.admin_teams_count_sum(:match_invitations_count)
    end
    
    @posts = @user.related_posts(:limit=>POST_LIST_LENGTH) if logged_in? && @user.id == self.current_user.id
    @bcs = Broadcast.get_related_broadcasts(@user, :limit=>BROADCAST_LIST_LENGTH).slice(0, 5) if logged_in? && @user.id == self.current_user.id
    @title = "#{@user.nickname}的主页"
  end
end

class TeamViewsController < ApplicationController
  layout "team_layout"
  
  TRAINING_LIST_LENGTH = 1
  USER_LIST_LENGTH = 9
  POSTS_LENGTH = 10
  MATCH_LIST_LENGTH = 1
  SIDED_MATCH_LIST_LENGTH = 1
  DISPLAY_DAYS = 14
  
  def show
    @team = Team.find(params[:id])
    @users = @team.users.find(:all, :limit => USER_LIST_LENGTH)
    
    if (logged_in? && current_user.is_team_member_of?(@team))
      @posts = @team.posts.find(:all, :limit=> POSTS_LENGTH)
    else
      @posts = @team.posts.public :limit=> POSTS_LENGTH
    end
    
    activities = []
    tmp = @team.trainings.recent(TRAINING_LIST_LENGTH)
    activities << tmp[0] if tmp.length > 0
    tmp = Match.find :all,
      :conditions => ['(host_team_id = ? or guest_team_id = ?) and end_time > ?', @team.id, @team.id, Time.now],
      :order => 'start_time',
      :limit => MATCH_LIST_LENGTH
    activities << tmp[0] if tmp.length > 0
    tmp = @team.sided_matches.recent(SIDED_MATCH_LIST_LENGTH)
    activities << tmp[0] if tmp.length > 0
    @recent_activity = activities.length > 0 ? (activities.sort_by{|act| act.start_time})[0] : nil
    
    @start_time = 3.days.ago.at_midnight
    et = @start_time.since(3600*24*DISPLAY_DAYS)
    @calendar_activities_hash = 
      (@team.trainings.in_a_duration(@start_time, et) +
       @team.sided_matches.in_a_duration(@start_time, et) +
       @team.match_calendar_proxy.in_a_duration(@start_time, et)).group_by{|t| t.start_time.strftime("%Y-%m-%d")}
    
    @formation_uts = UserTeam.find_all_by_team_id(@team.id, :conditions => ["position is not null"], :include => [:user])
    @formation_array = @formation_uts.map {|ut| ut.position}
    
    @user_team = logged_in? ? UserTeam.find_by_user_id_and_team_id(current_user, @team) : nil
    @team_join_request = logged_in? ? TeamJoinRequest.find_by_user_id_and_team_id_and_is_invitation(current_user, @team, false) : nil
    @team_join_invitation = logged_in? ? TeamJoinRequest.find_by_user_id_and_team_id_and_is_invitation(current_user, @team, true) : nil
    @can_request = logged_in? && @user_team == nil && @team_join_request == nil && @team_join_invitation==nil
    @can_quit = logged_in?  && @user_team != nil && # 可以退队
      @user_team.can_destroy_by?(current_user) # 处理唯一管理员的情况，唯一管理员不能退队
    
    @team_join_request_count = 0
    @match_invitation_count = 0
    if logged_in? && current_user.is_team_admin_of?(@team)
      @team_join_request_count = TeamJoinRequest.count(:conditions => ["team_id = ? and is_invitation = ?", @team, false])
      @match_invitation_count = MatchInvitation.count(:conditions=>["(host_team_id = ? and edit_by_host_team = ?) or (guest_team_id = ? and edit_by_host_team = ?)", @team, true, @team, false ])
    end
    
    @title = "#{@team.shortname}的首页"
  end
end

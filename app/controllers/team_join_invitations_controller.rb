class TeamJoinInvitationsController < ApplicationController
  before_filter :login_required
  
  def new
    if (params[:user_id] != nil)
      @user = User.find(params[:user_id], :include=>[:teams])
      @teams = (current_user.teams.admin - @user.teams)
      render :action => 'new_by_user_id'
    elsif (params[:team_id] != nil)
      @team = Team.find(params[:team_id], :include=>[:users])
      @friends = (current_user.friends - @team.users)
      render :action => 'new_by_team_id'
    else
      fake_params_redirect
    end
  end
  
  def index
    store_location
    if (params[:user_id]) # 显示所有邀请用户的队伍
        @requests = TeamJoinRequest.find_all_by_user_id_and_is_invitation(params[:user_id], true, :include=>[:team])
        render :action=>"index_team"
    else # 显示队伍所有邀请的用户
        @requests = TeamJoinRequest.find_all_by_team_id_and_is_invitation(params[:team_id], true, :include=>[:user])
        render :action=>"index_user"
    end
  end
  
  def create
    @team = Team.find(params[:team_join_request][:team_id])
    @user = User.find(params[:team_join_request][:user_id])
    
    # 管理员才可以邀请;
    # 如果已经在球队中，也不能邀请    
    if (!current_user.is_team_admin_of?(@team)||@user.is_team_member_of?(@team))
      fake_params_redirect
      return
    end
    params[:team_join_request][:is_invitation] = true;
    @tjs = TeamJoinRequest.find_or_initialize_by_team_id_and_user_id(@team.id,@user.id)    
    @tjs.team = @team
    @tjs.user = @user
    if @tjs.update_attributes(params[:team_join_request])
      redirect_to team_team_join_invitations_path(@team)
    else
      fake_params_redirect
    end
  end   
  
  def destroy
    @tjs = TeamJoinRequest.find(params[:id])
    if !@tjs.can_destroy_by?(self.current_user)
      fake_params_redirect
      return
    end
    @tjs.destroy
    redirect_back
  end
end

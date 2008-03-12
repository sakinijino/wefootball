class TeamJoinInvitationsController < ApplicationController
  before_filter :login_required
  
  def new
    if (params[:user_id] != nil)
      @user = User.find(params[:user_id])
      @teams = (current_user.teams.admin - @user.teams)
      render :action => 'new_by_user_id', :layout => "user_layout"
    elsif (params[:team_id] != nil)
      @team = Team.find(params[:team_id])
      if (!current_user.is_team_admin_of?(@team))
        fake_params_redirect
        return
      end
      @friends = (current_user.friends - @team.users)
      render :action => 'new_by_team_id', :layout => "team_layout"
    else
      fake_params_redirect
    end
  end
  
  def index
    if (params[:team_id]) # 显示队伍所有邀请的用户
      @team = Team.find(params[:team_id])
      if (current_user.is_team_admin_of?(params[:team_id]))
        @requests = TeamJoinRequest.find_all_by_team_id_and_is_invitation(params[:team_id], true, :include=>[:user])
        render :action=>"index_user", :layout => "team_layout"
      else
        fake_params_redirect
      end
    else  # 显示所有邀请用户的队伍
      @requests = TeamJoinRequest.find_all_by_user_id_and_is_invitation(self.current_user, true, :include=>[:team])
      @user = current_user
      render :action=>"index_team", :layout => "user_layout"
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
    @tjs = TeamJoinRequest.find_or_initialize_by_team_id_and_user_id_and_is_invitation(@team.id,@user.id, true)    
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
    else
      @tjs.destroy
      redirect_with_back_uri_or_default team_join_invitations_path
    end
  end
end

class TeamJoinInvitationsController < ApplicationController
  before_filter :login_required
  
  def new
    @teams = current_user.teams.admin.map{|t| [t.shortname,t.id]}
    @user_id = params[:user_id]
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
    if (!@team.users.admin.include?(self.current_user)) # 管理员才可以邀请
      fake_params_redirect
      return
    end
    if (@team.users.include?(@user)) # 如果已经在球队中，不能邀请     
      fake_params_redirect
      return
    end
    params[:team_join_request][:is_invitation] = true;
    @tjs = TeamJoinRequest.new(params[:team_join_request])
    if @tjs.save
      redirect_to team_path(@team)
      return
    else
      render :action=>"new",:user_id=>@user.id
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

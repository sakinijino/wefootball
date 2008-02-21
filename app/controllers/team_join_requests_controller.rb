class TeamJoinRequestsController < ApplicationController
  before_filter :login_required
  
  def new
    @team_id = params[:team_id]
  end  
  
  def index
    if (params[:user_id]) # 显示所有邀请用户的队伍
        @requests = TeamJoinRequest.find_all_by_user_id_and_is_invitation(params[:user_id], false, :include=>[:team])
        render :action=>"index_team"
    else # 显示队伍所有邀请的用户
        store_location
        @requests = TeamJoinRequest.find_all_by_team_id_and_is_invitation(params[:team_id], false, :include=>[:user])
        render :action=>"index_user"
    end
  end
  
  def create
    @team = Team.find(params[:team_join_request][:team_id])
    @user = current_user
    if (@user.is_team_member_of?(@team)) # 如果已经在球队中，不能申请     
      fake_params_redirect
      return
    end
    params[:team_join_request][:is_invitation] = false;
    @tjs = TeamJoinRequest.find_or_initialize_by_team_id_and_user_id(@team.id,@user.id)    
    @tjs.team = @team
    @tjs.user = @user
    if @tjs.update_attributes(params[:team_join_request])
      redirect_to team_path(@team)
    else
      @team_id = @team.id
      render :action=>"new"
    end
  end
  
  def destroy
    @tjs = TeamJoinRequest.find(params[:id],:include=>[:team])
    if (!@tjs.team.users.admin.include?(self.current_user)) # 管理员才可以删除
      fake_params_redirect
      return
    end
    @tjs.destroy
    redirect_to team_join_requests_path(:team_id=>@tjs.team.id)
  end
end
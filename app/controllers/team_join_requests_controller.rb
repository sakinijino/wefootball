class TeamJoinRequestsController < ApplicationController
  before_filter :login_required
  
  def index
    if (params[:team_id]) # 显示所有请求加入队伍的用户
      @team = Team.find(params[:team_id])
      if (current_user.is_team_admin_of?(params[:team_id]))
        @requests = TeamJoinRequest.find_all_by_team_id_and_is_invitation(params[:team_id], false, :include=>[:user])
        render :action=>"index_user", :layout => "team_layout"
      else
        fake_params_redirect
      end
    else # 显示所有用户请求加入队伍
      @requests = TeamJoinRequest.find_all_by_user_id_and_is_invitation(self.current_user, false, :include=>[:team])
      @user = current_user
      render :action=>"index_team", :layout => "user_layout"
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
    @tjs = TeamJoinRequest.find_or_initialize_by_team_id_and_user_id_and_is_invitation(@team.id,@user.id, false)    
    @tjs.team = @team
    @tjs.user = @user
    @tjs.update_attributes!(params[:team_join_request])
    redirect_to team_view_path(@team)
  end
  
  def destroy
    @tjs = TeamJoinRequest.find(params[:id],:include=>[:team])
    if (!@tjs.can_destroy_by?(self.current_user)) # 管理员才可以删除
      fake_params_redirect
    else
      @tjs.destroy
      redirect_with_back_uri_or_default team_team_join_requests_path(@tjs.team.id)
    end
  end
end
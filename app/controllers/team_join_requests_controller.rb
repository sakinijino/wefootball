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
    @user = User.find(params[:team_join_request][:user_id])
    if (@team.users.include?(@user)) # 如果已经在球队中，不能邀请     
      fake_params_redirect
      return
    end
    params[:team_join_request][:is_invitation] = false;
    @tjs = TeamJoinRequest.find_by_team_id_and_user_id(@team.id,@user.id)
    
    if (@tjs==nil)    
      @tjs = TeamJoinRequest.new(params[:team_join_request])
      if @tjs.save
        redirect_to team_path(@team)
        return
      else
        render :action=>"new",:team_id=>@team.id
      end
    else
      if @tjs.update_attributes(params[:team_join_request])
        redirect_to team_path(@team)
      else
        render :action=>"new",:team_id=>@team.id
      end
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
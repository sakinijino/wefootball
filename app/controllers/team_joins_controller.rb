class TeamJoinsController < ApplicationController
  before_filter :login_required
  
  def index
    store_location
    if (params[:user_id]) # 显示用户参加的所有队伍
      @uts = UserTeam.find_all_by_user_id(params[:user_id],:include=>[:team])
      render :action=>"index_team"
    else # 显示队伍的所有成员
      @uts = UserTeam.find_all_by_team_id(params[:team_id],:include=>[:user])
      @team_id = params[:team_id]
      render :action=>"index_user"
    end
  end  
  
  # POST /team_joins.xml
  def create
    @tjs = TeamJoinRequest.find(params[:id]) # 根据一个加入球队的请求来创建
    @user =@tjs.user
    @team = @tjs.team   
    
    if (@user.is_team_member_of?(@team)) #如果已经在球队中不能申请加入
      fake_params_redirect
      return
    end
    if !@tjs.can_accept_by?(self.current_user)
      fake_params_redirect
      return
    end
    
    UserTeam.transaction do
      @tjs.destroy
      @tu = UserTeam.new
      @tu.team = @team
      @tu.user = @user
      @tu.save
    end
    redirect_back
  end
  
  # PUT team_joins/1
  def update
    @tj = UserTeam.find(params[:id])
    @user =@tj.user
    @team = @tj.team
    if (!current_user.is_team_admin_of?(@team))
      fake_params_redirect
      return
    end
    params[:ut][:position] = nil if params[:ut][:position]==""
    params[:ut][:is_player] = false if !@user.is_playable
    params[:ut][:position] = nil if (@team.positions.size > 11)
    if(params[:ut][:is_admin] != @user.is_admin)
      if(
         (params[:ut][:is_admin] && !(@ut.is_admin && @ut.can_promote_as_admin_by?(current_user)))||
         (!params[:ut][:is_admin]  && !(@ut.is_admin && @ut.can_degree_as_common_user_by?(current_user)))
        )
      fake_params_redirect
      return       
      end      
    end
    if @tj.update_attributes(params[:ut])
      redirect_to team_team_joins_path(@team)
    else
      fake_params_redirect
    end
  end
  
  # DELETE team_joins/1
  def destroy
    @tj = UserTeam.find(params[:id])
    if (!@tj.can_destroy_by?(self.current_user))
      fake_params_redirect
      return
    end
    @tj.destroy
    redirect_back
  end
end

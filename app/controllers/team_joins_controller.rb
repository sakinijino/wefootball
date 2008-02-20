class TeamJoinsController < ApplicationController
  before_filter :login_required
  
  # POST /team_joins.xml
  def create
    @tjs = TeamJoinRequest.find(params[:id]) # 根据一个加入球队的请求来创建
    @user =@tjs.user
    @team = @tjs.team   
    
    if (@team.users.include?(@user)) #如果已经在球队中不能申请加入
      fake_params_redirect
      return
    end
    if !@tjs.can_accept_by?(self.current_user)
      fake_params_redirect
      return
    end
    @tjs.destroy
    @tu = UserTeam.new
    @tu.team = @team
    @tu.user = @user
    @tu.save
    redirect_back
  rescue ActiveRecord::RecordNotFound => e
    fake_params_redirect
  end
  
  # PUT /users/:user_id/teams/:team_id/team_joins.xml
  def update
    @tj = UserTeam.find_by_user_id_and_team_id(params[:user_id], params[:team_id])
    @user =@tj.user
    @team = @tj.team
    if (!@team.users.admin.include?(self.current_user))
      respond_to do |format|
        format.xml  { head 401 }
      end
      return
    end
    respond_to do |format|
      params[:team_join].delete :user_id #不能修改user_id和team_id
      params[:team_join].delete :team_id
      if @tj.update_attributes(params[:team_join])
        format.xml  { render :xml => @tj.to_xml(:dasherize=>false), :status => 200 }
      else
        format.xml  { render :xml => @tj.errors.to_xml_full, :status => 400 }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
  
  # DELETE /users/:user_id/teams/:team_id/team_joins.xml
  def destroy
    @tj = UserTeam.find_by_user_id_and_team_id(params[:user_id], params[:team_id])
    if (!@tj.can_destroy_by?(self.current_user))
      fake_params_redirect
      return
    end
    @tj.destroy
    redirect_to team_join_invitations_path
  rescue ActiveRecord::RecordNotFound => e
    fake_params_redirect
  end
end

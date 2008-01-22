class TeamJoinRequestsController < ApplicationController
  before_filter :login_required
  
  # GET /teams/:team_id/team_join_requests.xml
  # GET /users/:user_id/team_join_requests.xml
  def index
    if (params[:user_id]) #显示用户申请参加的所有队伍
      @user = User.find(params[:user_id])
      respond_to do |format|
        @requests = @user.request_join_teams
        format.xml  { render :status => 200, :template=>"shared/requests_with_teams" }
      end
    else #显示所有申请参加该队伍的用户
      @team = Team.find(params[:team_id])
      respond_to do |format|
        @requests = @team.request_join_users
        format.xml  { render :status => 200, :template=>"shared/requests_with_users" }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
  
  def create
    if params[:team_join_request][:user_id].to_s!=self.current_user.id.to_s
      respond_to do |format|
        format.xml {head 401}
      end
      return
    end
    @team = Team.find(params[:team_join_request][:team_id])
    if (@team.users.include?(self.current_user)) #如果已经在球队中不能申请加入
      respond_to do |format|
        format.xml {head 400}
      end
      return
    end
    params[:team_join_request][:is_invitation] = false;
    @tjs = TeamJoinRequest.new(params[:team_join_request])
    respond_to do |format|
      if @tjs.save
        format.xml  { render :xml => @tjs.to_xml(:dasherize=>false), :status => 200, :location => @tjs }
      else
        format.xml  { render :xml => @tjs.errors.to_xml_full, :status => 200 }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
  
  def destroy
    @tjs = TeamJoinRequest.find(params[:id])
    if !@tjs.can_destroy_by?(self.current_user)
      respond_to do |format|
        format.xml  { head 401 }
      end
      return
    end
    @tjs.destroy
    respond_to do |format|
      format.xml { head 200}
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
end
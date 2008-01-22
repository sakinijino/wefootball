class TeamJoinInvitationsController < ApplicationController
  before_filter :login_required
  
  def index
    if (params[:user_id])
      @user = User.find(params[:user_id])
      respond_to do |format|
        @requests = @user.invited_join_teams
        format.xml  { render :status => 200, :template=>"shared/requests_with_teams" }
      end
    else
      @team = Team.find(params[:team_id])
      respond_to do |format|
        @requests = @team.invited_join_users
        format.xml  { render :status => 200, :template=>"shared/requests_with_users" }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
  
  def create
    @team = Team.find(params[:team_join_request][:team_id])
    @user = User.find(params[:team_join_request][:user_id])
    if (!@team.users.admin.include?(self.current_user))
      respond_to do |format|
        format.xml {head 401}
      end
      return
    end
    if (@team.users.include?(@user))
      respond_to do |format|
        format.xml {head 400}
      end
      return
    end
    params[:team_join_request][:is_invitation] = true;
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

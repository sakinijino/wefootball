class TeamJoinRequestsController < ApplicationController
  before_filter :login_required
  
  def create
    if params[:team_join_request][:user_id]!=self.current_user.id
      respond_to do |format|
        format.xml {head 401}
      end
      return
    end
    @team = Team.find(params[:team_join_request][:team_id])
    if (@team.users.include?(self.current_user))
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
    if (!@tjs.team.users.admin.include?(self.current_user))
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
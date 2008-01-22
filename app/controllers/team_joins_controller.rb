class TeamJoinsController < ApplicationController
  before_filter :login_required
  
  def create
    @tjs = TeamJoinRequest.find(params[:id])
    @user =@tjs.user
    @team = @tjs.team
    if !@tjs.can_accept_by?(self.current_user)
      respond_to do |format|
        format.xml  { head 401 }
      end
      return
    end
    @tjs.destroy
    @tu = UserTeam.new
    @tu.team = @team
    @tu.user = @user
    @tu.save
    respond_to do |format|
      format.xml { head 200}
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
end

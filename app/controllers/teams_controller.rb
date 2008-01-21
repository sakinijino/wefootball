class TeamsController < ApplicationController
  before_filter :login_required, :only=>[:create, :update]
  # GET /teams
  # GET /teams.xml
#  def index
#    @teams = Team.find(:all)
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @teams }
#    end
#  end

  def show
    @team = Team.find(params[:id])
    respond_to do |format|
      format.xml  { render :xml => @team.to_xml(:dasherize=>false) }
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end

  def create
    @team = Team.new(params[:team])
    respond_to do |format|
      if @team.save
        @tu = UserTeam.new
        @tu.team = @team
        @tu.user = self.current_user
        @tu.is_admin = true
        @tu.save
        format.xml  { render :xml => @team.to_xml(:dasherize=>false), :status => 200, :location => @team }
      else
        format.xml  { render :xml => @team.errors.to_xml_full, :status => 400 }
      end
    end
  end

  def update
    @team = Team.find(params[:id])
    if (!@team.users.admin.include?(self.current_user))
      respond_to do |format|
        format.xml  { head 401 }
      end
      return
    end
    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.xml  { render :xml => @team.to_xml(:dasherize=>false), :status => 200, :location => @team }
      else
        format.xml  { render :xml => @team.errors.to_xml_full, :status => 400 }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
#
#  # DELETE /teams/1
#  # DELETE /teams/1.xml
#  def destroy
#    @team = Team.find(params[:id])
#    @team.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(teams_url) }
#      format.xml  { head :ok }
#    end
#  end
end

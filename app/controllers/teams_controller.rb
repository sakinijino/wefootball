class TeamsController < ApplicationController
  before_filter :login_required, :only=>[:create, :update]
  
  def new
  end

  def edit
    @team = Team.find(params[:id], :include=>[:team_image])
    fake_params_redirect if (!self.current_user.is_team_admin_of?(@team))
  end   
  
  # GET /users/:user_id/teams.xml
#  def index #列出用户参加的所有球队
#    @user = User.find(params[:user_id])
#    @teamsList = @user.teams
#  end
  
  # GET /teams/search.xml?query
  def search
    @teams = Team.find_by_contents(params[:q])
  end

 # GET /teams/1.xml
  def show
    @team = Team.find(params[:id], :include=>[:team_image])
  end

  # POST /teams.xml
  def create
    @team = Team.new(params[:team])
    if @team.save
      ut = UserTeam.new({:is_admin=>true});
      ut.user = current_user; ut.team = @team
      ut.save
      redirect_to team_path(@team)
    else
      render :action=>"new"
    end
  end

 # PUT /teams/1.xml
  def update
    @team = Team.find(params[:id], :include=>[:team_image])
    if (!self.current_user.is_team_admin_of?(@team))
      fake_params_redirect
      return
    end
    if (params[:team][:uploaded_data]!=nil)
      if update_image
        redirect_to edit_team_url(@team)
      else
        @team.team_image.errors.each do |attr, msg|
          @team.errors.add(attr, msg)
        end
        @team.team_image.reload
        render :action => "edit" 
      end
    else
      if @team.update_attributes(params[:team])
        redirect_to edit_team_path(params[:id])
      else
        render :action=>"edit"
      end
    end
  end
  
   # GET /users/:user_id/teams/admin.xml
  def admin #列出用户管理的所有球队
    @user = User.find(params[:user_id])
    @teamsList = @user.teams.admin
    render :action=>"index"
  end
  protected
  def update_image
    if (@team.team_image==nil)
      @team.team_image = TeamImage.new
    end
    if @team.team_image.update_attributes({:uploaded_data => params[:team][:uploaded_data]})
      @team.save
      true
    else
      false
    end
  end
end

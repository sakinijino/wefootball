class TeamsController < ApplicationController
  before_filter :login_required, :only=>[:create, :update]
  
  def new
  end

  def edit
    @team = Team.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      fake_params_redirect    
  end   
  
  # GET /users/:user_id/teams.xml
  def index #列出用户参加的所有球队
    @user = User.find(params[:user_id])
    @teamsList = @user.teams
  rescue ActiveRecord::RecordNotFound => e
    fake_params_redirect
  end
  
  # GET /teams/search.xml?query
  def search
    @teams = Team.find_by_contents(params[:q])
  end

 # GET /teams/1.xml
  def show
    @team = Team.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    fake_params_redirect
  end

  # POST /teams.xml
  def create
    @team = Team.new(params[:team])
    if @team.save
      @tu = UserTeam.new
      @tu.team = @team
      @tu.user = self.current_user
      @tu.is_admin = true
      @tu.save
      redirect_to team_path(@team)
    else
      render :action=>"new"
    end
  end

 # PUT /teams/1.xml
  def update
    @team = Team.find(params[:id])
    if (!@team.users.admin.include?(self.current_user))
      fake_params_redirect
      return
    end
    if @team.update_attributes(params[:team])
      redirect_to team_path(params[:id])
    else
      render :action=>"edit"
    end 
    rescue ActiveRecord::RecordNotFound => e
      fake_params_redirect
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

class TeamsController < ApplicationController
  before_filter :login_required, :except => [:search]
  before_filter :require_current_user_is_a_team_admin, :only => [:edit, :update, :update_image]
  
  def new
    @team = Team.new
  end

  # GET /teams/search.xml?query
  def search
    @teams = Team.find_by_contents(params[:q])
  end

  # POST /teams.xml
  def create
    @team = Team.new(params[:team])
    if @team.save
      ut = UserTeam.new({:is_admin=>true});
      ut.user = current_user; ut.team = @team
      ut.save
      redirect_to team_view_path(@team.id)
    else
      render :action=>"new"
    end
  end

  def edit
    @team = Team.find(params[:id])
  end
  
 # PUT /teams/1.xml
  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      redirect_to edit_team_path(params[:id])
    else
      render :action=>"edit"
    end
  end
  
  def update_image
    @team = Team.find(params[:id])
    team_image = TeamImage.find_or_initialize_by_team_id(@team.id)
    team_image.uploaded_data = params[:team][:uploaded_data]
    if team_image.save
      redirect_to edit_team_path(@team)
    else
      @team.errors.add_to_base('上传的必须是一张图片，而且大小不能超过2M') if !team_image.errors.empty?
      render :action => "edit" 
    end
  end
  
protected
  def require_current_user_is_a_team_admin
    fake_params_redirect if (!self.current_user.is_team_admin_of?(params[:id]))
  end
end

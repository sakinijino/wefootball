class TeamsController < ApplicationController
  before_filter :login_required, :only=>[:create, :update]
  
  def new
  end

  def edit
    fake_params_redirect if (!self.current_user.is_team_admin_of?(params[:id]))
    @team = Team.find(params[:id], :include=>[:team_image])
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

 # PUT /teams/1.xml
  def update
    @team = Team.find(params[:id], :include=>[:team_image])
    if (!self.current_user.is_team_admin_of?(@team))
      fake_params_redirect
      return
    end
    update_image if (params[:team][:uploaded_data]!=nil)
    if @team.update_attributes(params[:team])
      @team.team_image.save if params[:team][:uploaded_data]!=nil && @team.team_image!=nil
      redirect_to edit_team_path(params[:id])
    else
      @team.team_image.reload if @team.team_image!=nil
      render :action=>"edit"
    end
  end
  
protected
  def update_image
    @team.team_image = TeamImage.find_or_initialize_by_team_id(@team.id)
    @team.team_image.uploaded_data = params[:team][:uploaded_data]
  end
end

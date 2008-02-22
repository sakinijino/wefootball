class TrainingsController < ApplicationController
  before_filter :login_required

  # GET /users/:user_id/trainings
  # GET /teams/:team_id/trainings
  def index
    if (params[:user_id]) #显示用户参与的训练
      @user = User.find(params[:user_id], :include=>:trainings)
      @trainings = @user.trainings
      render :action=>'index_user'
    else #显示队伍的所有训练
      @team = Team.find(params[:team_id], :include=>:trainings)
      @trainings = @team.trainings
      render :action=>'index_team'
    end
  end

  # GET /trainings/1
  # GET /trainings/1.xml
  def show
    @training = Training.find(params[:id], :include=>[:team, :users])
  end
  
  def new
    @team = Team.find(params[:team_id])
    fake_params_redirect if (!current_user.is_team_admin_of?(@team))
  end

  # POST /trainings
  def create
    @team = Team.find(params[:training][:team_id])
    if (!current_user.is_team_admin_of?(@team))
      fake_params_redirect
      return
    end
    @training = Training.new(params[:training])
    @training.team = @team
    if @training.save
      redirect_to training_view_path(@training)
    else
      render :action=>"new"
    end
  end
  
  def edit
    @training = Training.find(params[:id], :include=>[:team])
    @team = @training.team
    fake_params_redirect if (!current_user.is_team_admin_of?(@training.team))
  end
  
  # PUT /trainings/1
  def update
    @training = Training.find(params[:id], :include=>[:team])
    if (!current_user.is_team_admin_of?(@training.team))
      fake_params_redirect
    elsif @training.update_attributes(params[:training])
      redirect_to training_view_path(params[:id])
    else
      render :action=>'edit'
    end
  end

  # DELETE /trainings/1
  def destroy
    @training = Training.find(params[:id], :include=>[:team])
    @team = @training.team
    if (!current_user.is_team_admin_of?(@training.team))
      fake_params_redirect
    else
      @training.destroy
      redirect_to team_view_path(@team)
    end
  end
end

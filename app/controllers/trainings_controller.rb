class TrainingsController < ApplicationController
  before_filter :login_required, :except => [:index]
  before_filter :parse_time, :only => [:create, :update]
  
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
  
  def new
    @team = Team.find(params[:team_id])
    fake_params_redirect if (!current_user.is_team_admin_of?(@team))
    @training = Training.new(:start_time => Time.now, :end_time => Time.now.since(3600))
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
    @training = Training.find(params[:id])
    @team = @training.team
    fake_params_redirect if (!current_user.is_team_admin_of?(@training.team))
  end
  
  # PUT /trainings/1
  def update
    @training = Training.find(params[:id])
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
    @training = Training.find(params[:id]) 
    if (!current_user.is_team_admin_of?(@training.team))
      fake_params_redirect
    else
      @training.destroy
      redirect_to team_view_path(@training.team_id)
    end
  end

 private
  def parse_time
    return if !params[:start_time] || !params[:end_time]
    params[:training] = {} if !params[:training]
    params[:training]["start_time(1i)"] = params[:start_time][:year]
    params[:training]["start_time(2i)"] = params[:start_time][:month]
    params[:training]["start_time(3i)"] = params[:start_time][:day]
    params[:training]["start_time(4i)"] = params[:start_time][:hour]
    params[:training]["start_time(5i)"] = params[:start_time][:minute]
    params[:training]["end_time(1i)"] = params[:start_time][:year]
    params[:training]["end_time(2i)"] = params[:start_time][:month]
    params[:training]["end_time(3i)"] = params[:start_time][:day]
    params[:training]["end_time(4i)"] = params[:end_time][:hour]
    params[:training]["end_time(5i)"] = params[:end_time][:minute]
  end
end

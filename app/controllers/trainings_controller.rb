class TrainingsController < ApplicationController
  before_filter :login_required
  before_filter :parse_time, :only => [:create, :update]
  
  def new
    @team = Team.find(params[:team_id])
    fake_params_redirect if (!current_user.is_team_admin_of?(@team))
    @training = Training.new(:start_time => Time.now.tomorrow, :end_time => Time.now.tomorrow.since(3600))
    @title = "创建新训练"
    render :layout => "team_layout"
  end

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
      render :action=>"new", :layout => "team_layout"
    end
  end
  
  def edit
    @training = Training.find(params[:id])
    @team = @training.team
    fake_params_redirect if (!@training.can_be_modified_by?(current_user))
    @title = "修改#{@training.start_time.strftime('%m月%d日')}训练的信息"
    render :layout => "training_layout"
  end
  
  def update
    @training = Training.find(params[:id])
    @team = @training.team
    if (!@training.can_be_modified_by?(current_user))
      fake_params_redirect
    elsif @training.update_attributes(params[:training])
      redirect_to training_view_path(params[:id])
    else
      render :action=>'edit', :layout => "training_layout"
    end
  end

  def destroy
    @training = Training.find(params[:id]) 
    if (!@training.can_be_destroyed_by?(current_user))
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

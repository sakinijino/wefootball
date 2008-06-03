class FootballGroundsController < ApplicationController
  before_filter :login_required, :except => [:show]
  before_filter :require_editor, :except => [:show, :new, :create]
  
  cache_sweeper :football_ground_sweeper,
                  :only =>  [:update]
  
  
  def unauthorize
    @football_grounds = FootballGround.find_all_by_status(0, :include => 'user')
    @title = "待审核球场"
    render :action => "index", :layout => "user_layout"
  end

  def show
    @football_ground = FootballGround.find(params[:id])
    @title = @football_ground.name
    trainings = @football_ground.trainings.in_later_hours(24)
    matches = @football_ground.matches.in_later_hours(24)
    sided_matches = @football_ground.sided_matches.in_later_hours(24)    
    plays = @football_ground.plays.in_later_hours(24)
    @activities = (trainings+matches+plays+sided_matches).group_by{|t| t.start_time.strftime("%Y-%m-%d")}
    @is_editor = logged_in? && FootballGroundEditor.is_a_editor?(current_user)
    
    @play = Play.new(:football_ground_id => @football_ground.id)
    @default_start_time = 1.hour.since
    @default_end_time = 2.hours.since
    render :layout => "user_layout"
  end

  def new
    @football_ground = FootballGround.new
    @title = '提交新球场资料'
    render :layout => "user_layout"
  end

  def edit
    @title = "编辑球场资料"
    @football_ground = FootballGround.find(params[:id])
    render :layout => "user_layout"
  end

  def create
    @football_ground = FootballGround.new(params[:football_ground])
    @football_ground.user = current_user
    if @football_ground.save
      redirect_with_back_uri_or_default '/'
    else
      render :action => "new", :layout => "user_layout"
    end
  end

  def update
    @football_ground = FootballGround.find(params[:id])
    if @football_ground.status !=0 && params[:football_ground][:status].to_s == '0'
      @football_ground.status = 1
    else
      @football_ground.status = params[:football_ground][:status]
    end
    if @football_ground.update_attributes(params[:football_ground])
      redirect_to(@football_ground)
    else
      render :action => "edit", :layout => "user_layout"
    end
  end

  def destroy
    @football_ground = FootballGround.find(params[:id])
    if @football_ground.status ==0
      @football_ground.destroy
      redirect_to unauthorize_football_grounds_path
    else
      fake_params_redirect
    end
  end
  
private
  def require_editor
    fake_params_redirect if !FootballGroundEditor.is_a_editor?(current_user)
  end
end

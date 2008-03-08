class FootballGroundsController < ApplicationController
  before_filter :login_required
  before_filter :require_editor, :except => [:show, :new, :create]
  
  def unauthorize
    @football_grounds = FootballGround.find_all_by_status(0, :include => 'user')
    render :action => "index"
  end

  # GET /football_grounds/1
  def show
    @football_ground = FootballGround.find(params[:id])
    @is_editor = current_user_is_football_ground_editor?
  end

  # GET /football_grounds/new
  def new
    @football_ground = FootballGround.new
  end

  # GET /football_grounds/1/edit
  def edit
    @football_ground = FootballGround.find(params[:id])
  end

  # POST /football_grounds
  def create
    @football_ground = FootballGround.new(params[:football_ground])
    @football_ground.user = current_user
    if @football_ground.save
      redirect_with_back_uri_or_default '/'
    else
      render :action => "new"
    end
  end

  # PUT /football_grounds/1
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
      render :action => "edit"
    end
  end

  # DELETE /football_grounds/1
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
    fake_params_redirect if !current_user_is_football_ground_editor?
  end
end

class TeamsController < ApplicationController
  before_filter :login_required, :except => [:search]
  before_filter :require_current_user_is_a_team_admin, :only => [:edit, :update, :update_image]
  before_filter :check_admins_limit, :only => [:new, :create]
  
  def new
    @user = current_user
    @team = Team.new
    @team.city = 0
    @title = "新建球队"
    render :layout => "user_layout"
  end

  def search
    if !params[:q].blank?
      @teams = Team.find_by_contents(params[:q])
      @title = "搜索“#{params[:q]}”的结果"
    end
    render :layout=>default_layout
  end

  def create
    @team = Team.new(params[:team])
    Team.transaction do
      if @team.save
        ut = UserTeam.new({:is_admin=>true});
        ut.user = current_user; ut.team = @team
        ut.is_player = current_user.is_playable;
        ut.save!
        redirect_with_back_uri_or_default team_view_path(@team.id)
      else
        @user = current_user
        @title = "新建球队"
        render :action=>"new", :layout => "user_layout"
      end
    end
  end

  def edit
    @team = Team.find(params[:id])
    @title = "修改球队信息"
    render :layout => "team_layout"
  end
  
  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      @title = "修改球队信息"
      flash[:notice] = "信息已保存"
      redirect_to edit_team_path(params[:id])
    else
      render :action=>"edit", :layout => "team_layout"
    end
  end
  
  def update_image
    @team = Team.find(params[:id])
    team_image = TeamImage.find_or_initialize_by_team_id(@team.id)
    team_image.uploaded_data = params[:team][:uploaded_data]
    if team_image.save
      @title = "修改球队信息"
      flash[:notice] = "队标已上传, 如果队标一时没有更新, 多刷新几次页面"
      redirect_to edit_team_path(@team)
    else
      @team.errors.add_to_base('上传的必须是一张图片, 而且大小不能超过2M') if !team_image.errors.empty?
      render :action => "edit", :layout => "team_layout"
    end
  end
  
protected
  def require_current_user_is_a_team_admin
    fake_params_redirect if (!self.current_user.is_team_admin_of?(params[:id]))
  end
  
  def check_admins_limit
    redirect_to user_view_path(current_user) if current_user.teams.admin.size >= UserTeam::MAX_ADMIN_LENGTH
  end
end

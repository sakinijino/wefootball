class OfficalTeamsController < ApplicationController
  before_filter :login_required
  before_filter :require_editor
  
  def index
    @title = "球队列表"
    @offical_teams = OfficalTeam.paginate :page => params[:page], :per_page => 2
    render :layout => default_layout
  end
  
  def new
    @title = "创建新球队"
    @offical_team = OfficalTeam.new
    render :layout => default_layout
  end

  def edit
    @title = "修改球队信息"
    @offical_team = OfficalTeam.find(params[:id])
    render :layout => default_layout
  end

  def create
    @offical_team = OfficalTeam.new(params[:offical_team])
    @offical_team.user = current_user
    if @offical_team.save
      flash[:notice] = '球队已经成功创建'
      redirect_to(edit_offical_team_path(@offical_team))
    else
      @title = "创建新球队"
      render :action => "new", :layout => default_layout
    end
  end

  def update
    @offical_team = OfficalTeam.find(params[:id])
    if @offical_team.update_attributes(params[:offical_team])
      flash[:notice] = '球队信息已经更新'
      redirect_to(edit_offical_team_path(@offical_team))
    else
      @title = "修改球队信息"
      render :action => "edit", :layout => default_layout
    end
  end
  
  def update_image
    @offical_team = OfficalTeam.find(params[:id])
    team_image = OfficalTeamImage.find_or_initialize_by_offical_team_id(@offical_team.id)
    team_image.uploaded_data = params[:offical_team][:uploaded_data]
    if team_image.save
      flash[:notice] = "队标已上传, 如果队标一时没有更新, 多刷新几次页面"
      redirect_to edit_offical_team_path(@offical_team)
    else
      @title = "修改球队信息"
      @offical_team.errors.add_to_base('上传图片只支持是jpg/gif/png格式, 并且图片大小不能超过2M') if !team_image.errors.empty?
      render :action => "edit", :layout => default_layout
    end
  end
  
private
  def require_editor
    fake_params_redirect if !OfficalTeamEditor.is_a_editor?(current_user)
  end
end

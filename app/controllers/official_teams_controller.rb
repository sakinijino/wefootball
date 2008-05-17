class OfficialTeamsController < ApplicationController
  before_filter :login_required
  before_filter :require_editor
  
  def index
    @title = "球队列表"
    @official_teams = OfficialTeam.paginate :page => params[:page], :per_page => 2
    render :layout => default_layout
  end
  
  def new
    @title = "创建新球队"
    @official_team = OfficialTeam.new
    render :layout => default_layout
  end

  def edit
    @title = "修改球队信息"
    @official_team = OfficialTeam.find(params[:id])
    render :layout => default_layout
  end

  def create
    @official_team = OfficialTeam.new(params[:official_team])
    @official_team.user = current_user
    if @official_team.save
      flash[:notice] = '球队已经成功创建'
      redirect_to(edit_official_team_path(@official_team))
    else
      @title = "创建新球队"
      render :action => "new", :layout => default_layout
    end
  end

  def update
    @official_team = OfficialTeam.find(params[:id])
    if @official_team.update_attributes(params[:official_team])
      flash[:notice] = '球队信息已经更新'
      redirect_to(edit_official_team_path(@official_team))
    else
      @title = "修改球队信息"
      render :action => "edit", :layout => default_layout
    end
  end
  
  def update_image
    @official_team = OfficialTeam.find(params[:id])
    team_image = OfficialTeamImage.find_or_initialize_by_official_team_id(@official_team.id)
    team_image.uploaded_data = params[:official_team][:uploaded_data]
    if team_image.save
      flash[:notice] = "队标已上传, 如果队标一时没有更新, 多刷新几次页面"
      redirect_to edit_official_team_path(@official_team)
    else
      @title = "修改球队信息"
      @official_team.errors.add_to_base('上传图片只支持是jpg/gif/png格式, 并且图片大小不能超过2M') if !team_image.errors.empty?
      render :action => "edit", :layout => default_layout
    end
  end
  
private
  def require_editor
    fake_params_redirect if !OfficialTeamEditor.is_a_editor?(current_user)
  end
end

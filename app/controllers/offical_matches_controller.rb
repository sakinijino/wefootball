class OfficalMatchesController < ApplicationController
  before_filter :login_required, :except => [:show, :index]
  before_filter :require_editor, :except => [:show, :index]

  def show
    @offical_match = OfficalMatch.find(params[:id])
    @is_editor = OfficalMatchEditor.is_a_editor?(current_user)
    @title = "#{@offical_match.host_team.name} v.s. #{@offical_match.guest_team.name}"
    render :layout => default_layout
  end

  def new
    @offical_match = OfficalMatch.new
    @offical_match.start_time = Time.now
    @title = "创建新比赛"
    render :layout => default_layout
  end

  def edit
    @offical_match = OfficalMatch.find(params[:id])
    @title = "修改比赛信息"
    render :layout => default_layout
  end

  def create
    @host_team = OfficalTeam.find params[:offical_match][:host_offical_team_id]
    @guest_team = OfficalTeam.find params[:offical_match][:guest_offical_team_id]    
    @offical_match = OfficalMatch.new(params[:offical_match])
    @offical_match.user = current_user
    if @offical_match.save
      redirect_to(offical_match_path(@offical_match))
    else
      render :action => "new"
    end
  end

  def update
    @host_team = OfficalTeam.find params[:offical_match][:host_offical_team_id]
    @guest_team = OfficalTeam.find params[:offical_match][:guest_offical_team_id]
    @offical_match = OfficalMatch.find(params[:id])
    if @offical_match.update_attributes(params[:offical_match])
      redirect_to(offical_match_path(@offical_match))
    else
      render :action => "edit"
    end
  end
  
  private
  def require_editor
    fake_params_redirect if !OfficalMatchEditor.is_a_editor?(current_user)
  end
end

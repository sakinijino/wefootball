class OfficialMatchesController < ApplicationController
  before_filter :login_required, :except => [:show, :index]
  before_filter :require_editor, :except => [:show, :index]

  REVIEW_LIST_LENGTH = 5
  
  def show
    @official_match = OfficialMatch.find(params[:id])
    @is_editor = OfficialMatchEditor.is_a_editor?(current_user)
    @title = "#{@official_match.host_team.name} v.s. #{@official_match.guest_team.name}"
    @reviews = @official_match.match_reviews.find(:all, :limit=>REVIEW_LIST_LENGTH, :order=>'score, created_at')
    render :layout => default_layout
  end

  def new
    @official_match = OfficialMatch.new
    @official_match.start_time = Time.now
    @title = "创建新比赛"
    render :layout => default_layout
  end

  def edit
    @official_match = OfficialMatch.find(params[:id])
    @title = "修改比赛信息"
    render :layout => default_layout
  end

  def create
    @host_team = OfficialTeam.find params[:official_match][:host_official_team_id]
    @guest_team = OfficialTeam.find params[:official_match][:guest_official_team_id]    
    @official_match = OfficialMatch.new(params[:official_match])
    @official_match.user = current_user
    if @official_match.save
      redirect_to(official_match_path(@official_match))
    else
      render :action => "new"
    end
  end

  def update
    @host_team = OfficialTeam.find params[:official_match][:host_official_team_id]
    @guest_team = OfficialTeam.find params[:official_match][:guest_official_team_id]
    @official_match = OfficialMatch.find(params[:id])
    if @official_match.update_attributes(params[:official_match])
      redirect_to(official_match_path(@official_match))
    else
      render :action => "edit"
    end
  end
  
  private
  def require_editor
    fake_params_redirect if !OfficialMatchEditor.is_a_editor?(current_user)
  end
end

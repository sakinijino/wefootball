class OfficialTeamsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :require_editor, :except => [:index, :show]
  
  def index
    @title = "球队列表"
    @is_editor = logged_in? && OfficialTeamEditor.is_a_editor?(current_user)
    
    @official_teams = OfficialTeam.paginate :page => params[:page], :per_page => 50
    render :layout => "user_layout"
  end
  
  DISPLAY_DAYS = 14
  REVIEW_LIST_LENGTH = 5
  def show
    @official_team = OfficialTeam.find(params[:id])
    @title = @official_team.name
    
    @rom = OfficialMatch.find :first, :conditions => 
      ['end_time > ? and (host_official_team_id = ? or guest_official_team_id = ?)', 
        Time.now, @official_team.id, @official_team.id],
      :order=>'start_time'
    
    @start_time = 3.days.ago.at_midnight
    et = @start_time.since(3600*24*DISPLAY_DAYS)
    @oms = OfficialMatch.find :all, :conditions =>
      ['(end_time > ? and start_time < ?) and (host_official_team_id = ? or guest_official_team_id = ?)', 
        @start_time, et, @official_team.id, @official_team.id], 
      :order=>'start_time'
    @om_hash = @oms.group_by {|t| t.start_time.strftime("%Y-%m-%d")}
    
    @reviews = OfficialMatchReview.find(:all, 
      :conditions => ['match_id in (?)', @oms.map {|om| om.id}],
      :limit=>REVIEW_LIST_LENGTH, 
      :order=>'like_count-dislike_count desc, like_count desc, created_at desc')
    @watches = Watch.find :all, 
      :conditions => ['official_match_id in (?)', @oms.map {|om| om.id}],
      :order=>'watch_join_count desc', 
      :limit=>10
    
    @is_editor = logged_in? && OfficialTeamEditor.is_a_editor?(current_user)
    render :layout => "official_team_layout"
  end
  
  def new
    @title = "创建新球队"
    @official_team = OfficialTeam.new
    render :layout => "user_layout"
  end

  def edit
    @title = "修改球队信息"
    @official_team = OfficialTeam.find(params[:id])
    render :layout => "official_team_layout"
  end

  def create
    @official_team = OfficialTeam.new(params[:official_team])
    @official_team.user = current_user
    if @official_team.save
      flash[:notice] = '球队已经成功创建'
      redirect_to(edit_official_team_path(@official_team))
    else
      @title = "创建新球队"
      render :action => "new", :layout => "user_layout"
    end
  end

  def update
    @official_team = OfficialTeam.find(params[:id])
    if @official_team.update_attributes(params[:official_team])
      flash[:notice] = '球队信息已经更新'
      redirect_to(edit_official_team_path(@official_team))
    else
      @title = "修改球队信息"
      render :action => "edit", :layout => "official_team_layout"
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
      render :action => "edit", :layout => "official_team_layout"
    end
  end
  
private
  def require_editor
    fake_params_redirect if !OfficialTeamEditor.is_a_editor?(current_user)
  end
end

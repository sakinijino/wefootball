class OfficialMatchesController < ApplicationController
  before_filter :login_required, :except => [:show, :index, :history]
  before_filter :require_editor, :except => [:show, :index, :history]

  REVIEW_LIST_LENGTH = 5
  RECENT_DAYS = 7
  HISTORY_DAYS = 7
  
  def index
    @official_matches = OfficialMatch.paginate :conditions => ['end_time > ? and start_time < ?', Time.now, RECENT_DAYS.days.since],
      :order=>'watch_join_count desc, start_time',
      :page => params[:page],
      :per_page => 15
    
    @watches = Watch.find :all, 
      :conditions => ['official_match_id in (?)', @official_matches.map{|om| om.id}], 
      :order=>'watch_join_count desc', 
      :limit=>15
    @title = "未来#{RECENT_DAYS}天内最受关注的比赛"
    
    @is_editor = OfficialMatchEditor.is_a_editor?(current_user)
    render :layout => default_layout
  end
  
  def history
    @official_matches = OfficialMatch.paginate :conditions => ['end_time > ? and end_time < ?', HISTORY_DAYS.days.ago, Time.now],
      :order=>'watch_join_count desc, start_time',
      :page => params[:page],
      :per_page => 15
    
    @reviews = OfficialMatchReview.find :all, 
      :conditions => ['match_id in (?)', @official_matches.map{|om| om.id}], 
      :order => 'like_count-dislike_count desc, like_count desc, created_at desc',
      :limit=>10
    
    @title = "过去#{HISTORY_DAYS}天内最受关注的比赛"
    @is_editor = OfficialMatchEditor.is_a_editor?(current_user)
    render :layout => default_layout
  end
  
  def show
    @official_match = OfficialMatch.find(params[:id])
    @reviews = @official_match.match_reviews.find(:all, 
      :limit=>REVIEW_LIST_LENGTH, 
      :order=>'like_count-dislike_count desc, like_count desc, created_at desc')
    @watches = @official_match.watches.find :all, :order=>'watch_join_count desc', :limit=>10
    
    @is_editor = OfficialMatchEditor.is_a_editor?(current_user)
    @title = "#{@official_match.host_team.name} V.S. #{@official_match.guest_team.name}"
    
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

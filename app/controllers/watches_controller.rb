class WatchesController < ApplicationController
  before_filter :login_required, :except => [:show, :index]  
  
  USERS_LIST_LENGTH = 18
  
  def index
    @official_match = OfficialMatch.find(params[:official_match_id])
    @watches = @official_match.watches.paginate :order=>'watch_join_count DESC', :page => params[:page], :per_page => 15
    @title = "#{@official_match.host_team_name} V.S. #{@official_match.guest_team_name}比赛下的看球活动"
    render :layout => default_layout
  end
  
  def show
    @watch = Watch.find(params[:id])
    @users = @watch.users.find(:all,:limit=>USERS_LIST_LENGTH)
    @official_match = @watch.official_match
    @is_admin = logged_in? && (@watch.admin.id == current_user.id)
    @title = "观看#{@official_match.host_team_name} V.S. #{@official_match.guest_team_name}比赛的活动信息"
    render :layout => default_layout
  end
  
  def users
    @watch = Watch.find(params[:id])    
    @official_match = @watch.official_match
    @title = "观看#{@official_match.host_team_name} V.S. #{@official_match.guest_team_name}比赛的人"
    @users = @watch.users.paginate(:page => params[:page], :per_page => 100)
    render :layout => default_layout    
  end

  def new
    @watch = Watch.new
    @official_match = OfficialMatch.find(params[:official_match_id])    
    @watch.start_time = @official_match.start_time
    @watch.end_time = @official_match.end_time
    @title = "观看#{@official_match.host_team_name} V.S. #{@official_match.guest_team_name}的比赛"
    render :layout => default_layout    
  end

  def create 
    @official_match = OfficialMatch.find(params[:watch][:official_match_id])   
    @watch = Watch.new(params[:watch])
    @watch.official_match = @official_match
    @watch.admin = current_user    
    @title = "观看#{@official_match.host_team_name} V.S. #{@official_match.guest_team_name}的比赛"
    
    Watch.transaction do
      @watch.save! 
      WatchJoin.create!(:watch_id=>@watch.id,:user_id=>current_user.id)    
      redirect_to watch_path(@watch)
    end
    rescue ActiveRecord::RecordInvalid => e
      render :action => 'new', :layout => default_layout 
  end

  def edit
    @watch = Watch.find(params[:id])    
    if !@watch.can_be_edited_by? current_user
      fake_params_redirect
      return
    end
    @official_match = @watch.official_match
    @title = "修改看球活动的信息"
    render :layout => default_layout    
  end

  def update
    @watch = Watch.find(params[:id])
    if !@watch.can_be_edited_by? current_user
      fake_params_redirect
      return
    end
    @official_match = @watch.official_match
    @title = "修改看球活动的信息"
    if @watch.update_attributes(params[:watch])   
      redirect_to(watch_path(@watch))
    else
      render :action => "edit", :layout => default_layout 
    end
  end

  def destroy
    @watch = Watch.find(params[:id])    
    if !@watch.can_be_destroyed_by? current_user
      fake_params_redirect 
      return
    end
    @watch.destroy
    redirect_to official_match_path(@watch.official_match_id)
  end
  
  def select_new_admin
    @watch = Watch.find(params[:id])
    if !@watch.can_be_edited_by?(current_user)
      fake_params_redirect
      return
    end
    @title = "选择继任管理员，然后退出看球活动"
    @wjs = @watch.watch_joins.paginate :conditions => ["user_id != ?", current_user.id],
      :include=>[:user],
      :page => params[:page], 
      :per_page => 50
    render :layout => default_layout
  end
end

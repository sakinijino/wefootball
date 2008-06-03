class TrainingsController < ApplicationController
  before_filter :login_required, :except => [:show, :joined_users, :undetermined_users]
  before_filter :parse_time, :only => [:create, :update]
  
  POSTS_LENGTH = 10
  JOINED_USER_LIST_LENGTH = 9
  UNDETERMINED_USER_LIST_LENGTH = 9 
  
  def show
    @training = Training.find(params[:id])
    
    if (logged_in? && current_user.is_team_member_of?(@training.team_id))
      @posts = @training.posts.find(:all, :limit=>POSTS_LENGTH)
    else
      @posts = @training.posts.public :limit=>POSTS_LENGTH
    end
    
    @team = @training.team
    @joined_users = @training.users.joined(:limit=>JOINED_USER_LIST_LENGTH)
    @undetermined_users = @training.users.undetermined(:limit=>UNDETERMINED_USER_LIST_LENGTH)    
    render :layout=>'training_layout'
  end
  
  def joined_users
    @training = Training.find(params[:id])
    @title = "参见#{@training.team.shortname} #{@training.start_time.strftime('%m.%d')}训练的人"
    @users = @training.users.joined :page => params[:page], :per_page => 100
    @team = @training.team
    render :action=>'users', :layout=>'training_layout'    
  end
  
  def undetermined_users
    @training = Training.find(params[:id])
    @title = "没表态是否参加#{@training.team.shortname} #{@training.start_time.strftime('%m.%d')}训练的人"
    @users = @training.users.undetermined :page => params[:page], :per_page => 100
    @team = @training.team
    render :action=>'users', :layout=>'training_layout'    
  end  
  
  def new
    @team = Team.find(params[:team_id])
    fake_params_redirect if (!current_user.is_team_admin_of?(@team))
    @training = Training.new(:start_time => Time.now.tomorrow, :end_time => Time.now.tomorrow.since(3600))
    @title = "创建新训练"
    render :layout => "training_layout"
  end

  def create
    @team = Team.find(params[:training][:team_id])
    if (!current_user.is_team_admin_of?(@team))
      fake_params_redirect
      return
    end
    
    @training = Training.new(params[:training])
    @training.team = @team
    if @training.save
      redirect_to training_path(@training)
    else
      render :action=>"new", :layout => "training_layout"
    end
  end
  
  def edit
    @training = Training.find(params[:id])
    @team = @training.team
    if (!@training.can_be_modified_by?(current_user))
      fake_params_redirect
      return
    end
    @title = "修改#{@training.start_time.strftime('%m月%d日')}训练的信息"
    render :layout => "training_layout"
  end
  
  def update
    @training = Training.find(params[:id])
    @team = @training.team
    if (!@training.can_be_modified_by?(current_user))
      fake_params_redirect
    elsif @training.update_attributes(params[:training])
      redirect_to training_path(params[:id])
    else
      @title = "修改#{@training.start_time.strftime('%m月%d日')}训练的信息"
      render :action=>'edit', :layout => "training_layout"
    end
  end

  def destroy
    @training = Training.find(params[:id]) 
    if (!@training.can_be_destroyed_by?(current_user))
      fake_params_redirect
    else
      @training.destroy
      redirect_to team_view_path(@training.team_id)
    end
  end

 private
  def parse_time
    return if !params[:start_time] || !params[:end_time]
    params[:training] = {} if !params[:training]
    params[:training]["start_time(1i)"] = params[:start_time][:year]
    params[:training]["start_time(2i)"] = params[:start_time][:month]
    params[:training]["start_time(3i)"] = params[:start_time][:day]
    params[:training]["start_time(4i)"] = params[:start_time][:hour]
    params[:training]["start_time(5i)"] = params[:start_time][:minute]
    params[:training]["end_time(1i)"] = params[:start_time][:year]
    params[:training]["end_time(2i)"] = params[:start_time][:month]
    params[:training]["end_time(3i)"] = params[:start_time][:day]
    params[:training]["end_time(4i)"] = params[:end_time][:hour]
    params[:training]["end_time(5i)"] = params[:end_time][:minute]
  end
end

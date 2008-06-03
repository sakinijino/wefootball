class PostsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :before_modify, :only=>[:edit, :update]
  
  POSTS_PER_PAGE = 30
  REPLIES_PER_PAGE = 100
  
  def index
    if (params[:sided_match_id])
      @activity = SidedMatch.find(params[:sided_match_id])
      @team = @activity.team
      if (logged_in? && current_user.is_team_member_of?(@team.id))
        @posts = @activity.posts.paginate(:page => params[:page], :per_page => POSTS_PER_PAGE)
      else
        @posts = @activity.posts.public(:page => params[:page], :per_page => POSTS_PER_PAGE)
      end
      @title = "讨论对阵 #{@activity.guest_team_name} 的比赛"
      @match = @activity
      render :layout => "match_layout"
    elsif (params[:team_id] && params[:match_id])
      @activity = Match.find(params[:match_id])
      @team = Team.find(params[:team_id])
      if (logged_in? && current_user.is_team_member_of?(@team.id))
        @posts = @activity.posts.team(@team, :page => params[:page], :per_page => POSTS_PER_PAGE)
      else
        @posts = @activity.posts.team_public(@team, :page => params[:page], :per_page => POSTS_PER_PAGE)
      end
      @title = "讨论对阵 #{(@activity.host_team != @team ? @activity.host_team : @activity.guest_team).shortname} 的比赛"
      @match = @activity
      render :layout => "match_layout"
    elsif (params[:training_id])
      @activity = Training.find(params[:training_id])
      @team = @activity.team
      if (logged_in? && current_user.is_team_member_of?(@team.id))
        @posts = @activity.posts.paginate(:page => params[:page], :per_page => POSTS_PER_PAGE)
      else
        @posts = @activity.posts.public(:page => params[:page], :per_page => POSTS_PER_PAGE)
      end
      @title = "#{@activity.team.shortname} #{@activity.start_time.strftime('%m.%d')}训练的讨论"
      render :layout => "training_layout"
    elsif (params[:team_id])
      @team = Team.find(params[:team_id])
      @title = "#{@team.shortname}下的讨论"
      respond_to do |format| 
        format.html  {
          if (logged_in? && current_user.is_team_member_of?(@team.id))
            @posts = @team.posts.paginate(:page => params[:page], :per_page => POSTS_PER_PAGE)
          else
            @posts = @team.posts.public(:page => params[:page], :per_page => POSTS_PER_PAGE)
          end
          @display_rss_link = true
          render :layout => "team_layout"
        }
        format.atom {
          @posts = Post.find :all, 
            {:conditions => ['team_id = ? and is_private = ?', @team, false], 
             :limit => 20, 
             :order => "created_at desc"}
        }
      end
    elsif params[:watch_id]
      @activity = Watch.find(params[:watch_id])
      @user = current_user
      if (logged_in? && @activity.has_member?(current_user))
        @posts = @activity.posts.paginate(:page => params[:page], :per_page => POSTS_PER_PAGE)
      else
        @posts = @activity.posts.public(:page => params[:page], :per_page => POSTS_PER_PAGE)
      end
      @title = "本次看球活动下的讨论"
      @match = @activity.official_match
      render :layout => "match_layout"
    else
      fake_params_redirect
    end
  end
  
  TEAM_LIST_LENGTH = 9
  
  def related
    @user = current_user
    @posts = current_user.related_posts :page => params[:page], :per_page => POSTS_PER_PAGE
    @title = "我的讨论更新"
    render :layout => "user_layout"
  end

  def show
    @post = Post.find(params[:id])
    if !@post.is_visible_to?(current_user) 
      fake_params_redirect
      return
    end
    @replies = @post.replies.paginate(:page => params[:page], :per_page => REPLIES_PER_PAGE)
    @can_reply = logged_in? && @post.can_be_replied_by?(current_user)
    @activity = @post.activity  
    @related_posts = @post.related(logged_in? ? current_user : nil, :limit => 20) 
    @title = @post.title
    render :layout => post_layout
  end

  def new
    if (params[:sided_match_id])
      @activity = SidedMatch.find(params[:sided_match_id])
      @team = @activity.team
      @posts_url = sided_match_posts_path(@activity)
      @title = "讨论对阵 #{@activity.guest_team_name} 的比赛"
      @post = SidedMatchPost.new
      if !current_user.is_team_member_of?(@team.id)
        fake_params_redirect 
        return
      end
      @match = @activity
      render :layout => "match_layout"
    elsif (params[:match_id])
      @activity = Match.find(params[:match_id])
      @team = Team.find(params[:team_id])
      @posts_url = match_team_posts_path(@activity, @team)
      @title = "讨论对阵 #{(@activity.host_team_id != @team.id ? @activity.host_team : @activity.guest_team).shortname} 的比赛"
      @post = MatchPost.new
      @match = @activity
      if !current_user.is_team_member_of?(@team.id)
        fake_params_redirect 
        return
      end
      render :layout => 'match_layout'       
    elsif (params[:training_id])
      @activity = Training.find(params[:training_id])
      @team = @activity.team
      @posts_url = training_posts_path(@activity)
      @title = "讨论#{@team.shortname} #{@activity.start_time.strftime('%m.%d')}的训练"
      @post = TrainingPost.new
      if !current_user.is_team_member_of?(@team.id)
        fake_params_redirect 
        return
      end
      render :layout => 'training_layout'      
    elsif (params[:team_id])
      @activity = nil
      @team = Team.find(params[:team_id])
      @posts_url = team_posts_path(@team)
      @title = "在#{@team.shortname}的讨论区中发言" if @team
      @post = Post.new
      if !current_user.is_team_member_of?(@team.id)
        fake_params_redirect 
        return
      end
      render :layout => 'team_layout'       
    elsif (params[:watch_id])
      @activity = Watch.find(params[:watch_id])
      @posts_url = watch_posts_path(@activity)
      @title = "在本次看球活动中中发言"
      @post = WatchPost.new
      if !@activity.has_member?(current_user)
        fake_params_redirect 
        return
      end
      @match = @activity.official_match
      render :layout => "match_layout"
    end    
  end

  def create
    if (params[:sided_match_id])
      @activity = SidedMatch.find(params[:sided_match_id])
      @team = @activity.team
      @post = SidedMatchPost.new(params[:post])
      @posts_url = sided_match_posts_path(@activity)
      if !current_user.is_team_member_of?(@team.id)
        fake_params_redirect 
        return
      end
      @post.team = @team
      @match = @activity
      layout = "match_layout"
    elsif (params[:match_id])
      @activity = Match.find(params[:match_id])
      @team = Team.find(params[:team_id])
      @posts_url = match_team_posts_path(@activity, @team)
      @post = MatchPost.new(params[:post])
      if !current_user.is_team_member_of?(@team.id)
        fake_params_redirect 
        return
      end
      @post.team = @team
      @match = @activity
      layout = 'match_layout'      
    elsif (params[:training_id])
      @activity = Training.find(params[:training_id])
      @team = @activity.team
      @post = TrainingPost.new(params[:post])
      @posts_url = training_posts_path(@activity)
      if !current_user.is_team_member_of?(@team.id)
        fake_params_redirect 
        return
      end
      @post.team = @team
      layout = 'training_layout'      
    elsif (params[:team_id])
      @activity = nil
      @team = Team.find(params[:team_id])
      @post = Post.new(params[:post])
      @posts_url = team_posts_path(@team)
      if !current_user.is_team_member_of?(@team.id)
        fake_params_redirect 
        return
      end
      @post.team = @team
      layout = 'team_layout'      
    elsif params[:watch_id]
      @activity = Watch.find(params[:watch_id])
      @post = WatchPost.new(params[:post])
      @posts_url = watch_posts_path(@activity)
      if !@activity.has_member?(current_user)
        fake_params_redirect 
        return
      end
      @match = @activity.official_match
      layout = "match_layout"
    end
    
    @post.activity = @activity
    @post.user = current_user
    if @post.save
      redirect_to(post_path(@post))
    else
      render :action => "new", :layout => layout
    end      
  end
  
  def edit
    @title = "修改发言"
    render :layout => post_layout
  end

  def update
    if @post.update_attributes(params[:post])
      redirect_to(post_path(@post))
    else
      render :action => "edit", :layout => post_layout
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if !@post.can_be_destroyed_by?(current_user)
      fake_params_redirect
    else
      @post.destroy
      if @post.activity_id.nil?
        redirect_to team_posts_url(@post.team_id)
      else
        case @post
        when WatchPost
          redirect_to watch_posts_url(@post.activity_id)
        when MatchPost
          redirect_to match_team_posts_url(@post.activity_id, @post.team_id)
        when SidedMatchPost
          redirect_to sided_match_posts_url(@post.activity_id)
        when TrainingPost
          redirect_to training_posts_url(@post.activity_id)
        else
          redirect_to team_posts_url(@post.team_id)
        end
      end
    end
  end

protected  
  def before_modify
    @post = Post.find(params[:id])
    fake_params_redirect if !@post.can_be_modified_by?(current_user)
  end
  
  def post_layout
    @team = @post.team
    case @post
    when MatchPost
      @match = @post.activity
      @match.nil? ? "team_layout" : "match_layout"
    when SidedMatchPost
      @match = @post.activity
      @match.nil? ? "team_layout" : "match_layout"
    when TrainingPost
      @post.training.nil? ? "team_layout" : "training_layout"
    when WatchPost
      @match = @post.activity.official_match
      "match_layout"
    else
      "team_layout" 
    end    
  end  
end

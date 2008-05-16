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
      render :layout => "team_layout"
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
      render :layout => "team_layout"
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
    else
      fake_params_redirect
    end
  end
  
  TEAM_LIST_LENGTH = 9
  
  def related
    @user = current_user
    @teams = @user.teams.find(:all, :limit => TEAM_LIST_LENGTH)
    @posts = current_user.related_posts :page => params[:page], :per_page => POSTS_PER_PAGE
    @title = "我所在球队的讨论更新"
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
    @team = @post.team
    @activity = @post.activity
    
    if (logged_in? && current_user.is_team_member_of?(@team))
      @related_posts = @team.posts.find(:all, :limit => 20) - [@post]
    else
      @related_posts = @team.posts.find(:all, :conditions => ['is_private = ?', false], :limit => 20) - [@post]
    end
    
    @title = @post.title
    render :layout => post_layout(@post)
  end

  def new
    if (params[:sided_match_id])
      @activity = SidedMatch.find(params[:sided_match_id])
      @team = @activity.team
      @posts_url = sided_match_posts_path(@activity)
      @title = "讨论对阵 #{@activity.guest_team_name} 的比赛"
      @post = SidedMatchPost.new
    elsif (params[:match_id])
      @activity = Match.find(params[:match_id])
      @team = Team.find(params[:team_id])
      @posts_url = match_team_posts_path(@activity, @team)
      @title = "讨论对阵 #{(@activity.host_team_id != @team.id ? @activity.host_team : @activity.guest_team).shortname} 的比赛"
      @post = MatchPost.new
      @match = @activity
    elsif (params[:training_id])
      @activity = Training.find(params[:training_id])
      @team = @activity.team
      @posts_url = training_posts_path(@activity)
      @title = "讨论#{@team.shortname} #{@activity.start_time.strftime('%m.%d')}的训练"
      @post = TrainingPost.new
    elsif (params[:team_id])
      @activity = nil
      @team = Team.find(params[:team_id])
      @posts_url = team_posts_path(@team)
      @title = "在#{@team.shortname}的讨论区中发言" if @team
      @post = Post.new
    end
    
    if !current_user.is_team_member_of?(@team.id)
      fake_params_redirect 
      return
    end
    
    render :layout => post_layout(@post)
  end

  def create
    if (params[:sided_match_id])
      @activity = SidedMatch.find(params[:sided_match_id])
      @team = @activity.team
      @post = SidedMatchPost.new(params[:post])
    elsif (params[:match_id])
      @activity = Match.find(params[:match_id])
      @team = Team.find(params[:team_id])
      @post = MatchPost.new(params[:post])
    elsif (params[:training_id])
      @activity = Training.find(params[:training_id])
      @team = @activity.team
      @post = TrainingPost.new(params[:post])
    elsif (params[:team_id])
      @activity = nil
      @team = Team.find(params[:team_id])
      @post = Post.new(params[:post])
    end
    
    if !current_user.is_team_member_of?(@team.id)
      fake_params_redirect 
      return
    end
    
    @post.team = @team
    @post.activity = @activity
    @post.user = current_user
    if @post.save
      redirect_to(post_path(@post))
    else
      render :action => "new", :layout => post_layout(@post)
    end
  end
  
  def edit
    @title = "修改发言"
    @team = @post.team
    render :layout => post_layout(@post)
  end

  def update
    if @post.update_attributes(params[:post])
      redirect_to(post_path(@post))
    else
      render :action => "edit", :layout => post_layout(@post)
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if !@post.can_be_destroyed_by?(current_user)
      fake_params_redirect
    else
      @post.destroy
      redirect_to team_posts_url(@post.team_id)
    end
  end

protected  
  def before_modify
    @post = Post.find(params[:id])
    fake_params_redirect if !@post.can_be_modified_by?(current_user)
  end
  
  def post_layout(p)
    case @post
    when MatchPost
      @match = @post.match if !@match
      "match_layout"
    else
      "team_layout" 
    end
  end
end

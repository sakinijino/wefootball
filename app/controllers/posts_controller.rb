class PostsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :before_post, :only=>[:new, :create]
  before_filter :before_modify, :only=>[:edit, :update]
  
  def index
    if (params[:sided_match_id])
      @sided_match = SidedMatch.find(params[:sided_match_id])
      @team = @sided_match.team
      if (logged_in? && current_user.is_team_member_of?(@team.id))
        @posts = @sided_match.posts
      else
        @posts = @sided_match.posts.public
      end
      @title = "讨论对阵 #{@sided_match.guest_team_name} 的比赛"
      render :layout => "team_layout"
    elsif (params[:team_id] && params[:match_id])
      @match = Match.find(params[:match_id])
      @team = Team.find(params[:team_id])
      if (logged_in? && current_user.is_team_member_of?(@team.id))
        @posts = @match.posts.team(@team)
      else
        @posts = @match.posts.team_public(@team)
      end
      @title = "讨论对阵 #{(@match.host_team != @team ? @match.host_team : @match.guest_team).shortname} 的比赛"
      render :layout => "match_layout"
    elsif (params[:team_id])
      @team = Team.find(params[:team_id])
      if (logged_in? && current_user.is_team_member_of?(@team))
        @posts = @team.posts
      else
        @posts = @team.posts.public
      end
      @title = "#{@team.shortname}下的讨论"
      render :layout => "team_layout"
    elsif (params[:training_id])
      @training = Training.find(params[:training_id])
      @team = @training.team
      if (logged_in? && current_user.is_team_member_of?(@training.team_id))
        @posts = @training.posts
      else
        @posts = @training.posts.public
      end
      @title = "#{@training.team.shortname} #{@training.start_time.strftime('%m.%d')}训练的讨论"
      render :layout => "team_layout"
    else
      fake_params_redirect
    end
  end

  def show
    @post = Post.find(params[:id])
    if !@post.is_visible_to?(current_user) 
      fake_params_redirect
      return
    end
    @can_reply = logged_in? && @post.can_be_replied_by?(current_user)
    @team = @post.team
    @training = @post.training
    @match = @post.match
    @sided_match = @post.sided_match
    
    if (logged_in? && current_user.is_team_member_of?(@team))
      @related_posts = @team.posts.find(:all, :limit => 20) - [@post]
    else
      @related_posts = @team.posts.find(:all, :conditions => ['is_private = ?', false], :limit => 20) - [@post]
    end

    if @match
      render :layout => "match_layout"
    else
      render :layout => "team_layout" 
    end
  end

  def new
    @post = Post.new
    if (params[:team_id] && params[:match_id])
      render :layout => "match_layout"
    else
      render :layout => "team_layout" 
    end
  end

  def edit
    @team = @post.team
    @match = @post.match
    if @match
      render :layout => "match_layout"
    else
      render :layout => "team_layout" 
    end
  end

  def create
    @post = Post.new(params[:post])
    @post.team_id = @tid
    @post.training = @training if @training
    @post.match = @match if @match
    @post.sided_match = @sided_match if @sided_match
    @post.user = current_user
    if @post.save
      redirect_to(@post)
    else
      render :action => "new", :layout => "team_layout" 
    end
  end

  def update
    if @post.update_attributes(params[:post])
      redirect_to(@post)
    else
      @match = @post.match
      if @match
        render :action => "edit", :layout => "match_layout"
      else
        render :action => "edit", :layout => "team_layout" 
      end
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
  def before_post
    if (params[:sided_match_id])
      @sided_match = SidedMatch.find(params[:sided_match_id])
      @team = @sided_match.team
    elsif (params[:team_id] && params[:match_id])
      @team = Team.find(params[:team_id])
      @match = Match.find(params[:match_id])
    elsif (params[:team_id])
      @team = Team.find(params[:team_id])
    elsif (params[:training_id])
      @training = Training.find(params[:training_id])
      @team = @training.team
    end
    @tid = @team.id
    fake_params_redirect if !current_user.is_team_member_of?(@tid)
    @title = "在#{@team.shortname}的讨论区中发言" if @team
    @title = "讨论#{@team.shortname} #{@training.start_time.strftime('%m.%d')}的训练" if @training
    @title = "讨论对阵 #{(@match.host_team != @team ? @match.host_team : @match.guest_team).shortname} 的比赛" if @match
    @title = "讨论对阵 #{@sided_match.guest_team_name} 的比赛" if @sided_match
  end
  
  def before_modify
    @post = Post.find(params[:id])
    fake_params_redirect if !@post.can_be_modified_by?(current_user)
    @title = "修改发言"
  end
end

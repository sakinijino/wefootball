class PostsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :before_post, :only=>[:new, :create]
  before_filter :before_modify, :only=>[:edit, :update]
  
  # GET teams/1/posts
  # GET trainings/1/posts
  def index
    if (params[:team_id])
      @team = Team.find(params[:team_id])
      if (logged_in? && current_user.is_team_member_of?(@team))
        @posts = @team.posts
      else
        @posts = @team.posts.public
      end
    elsif (params[:training_id])
      @training = Training.find(params[:training_id])
      if (logged_in? && current_user.is_team_member_of?(@training.team_id))
        @posts = @training.posts
      else
        @posts = @training.posts.public
      end
    else
      fake_params_redirect
    end
  end

  # GET /posts/1
  def show
    @post = Post.find(params[:id])
    fake_params_redirect if !@post.is_visible_to?(current_user)
  end

  # GET teams/1/posts/new
  # GET trainings/1/posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST teams/1/posts
  # POST trainings/1/posts
  def create
    @post = Post.new(params[:post])
    @post.team_id = @tid
    @post.training = @training if @training
    @post.user = current_user
    if @post.save
      redirect_to(@post)
    else
      render :action => "new"
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    if @post.update_attributes(params[:post])
      redirect_to(@post)
    else
      render :action => "edit"
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
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
    if (params[:team_id])
      @team = Team.find(params[:team_id])
      @tid = @team.id
    elsif (params[:training_id])
      @training = Training.find(params[:training_id])
      @tid = @training.team_id
    end
    fake_params_redirect if !current_user.is_team_member_of?(@tid)
  end
  
  def before_modify
    @post = Post.find(params[:id])
    fake_params_redirect if !@post.can_be_modified_by?(current_user)
  end
end

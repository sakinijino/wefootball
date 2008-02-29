class PostsController < ApplicationController
  # GET teams/1/posts
  # GET trainings/1/posts
  def index
    if (params[:team_id])
      @team = Team.find(params[:team_id])
      if (current_user.is_team_member_of?(@team))
        @posts = @team.posts
      else
        @posts = @team.posts.public
      end
    elsif (params[:training_id])
      @training = Training.find(params[:training_id])
      if (current_user.is_team_member_of?(@training.team_id))
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
  end

  # GET teams/1/posts/new
  # GET trainings/1/posts/new
  def new
    if (!can_post)
      fake_params_redirect
      return
    end
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST teams/1/posts
  # POST trainings/1/posts
  def create
    if (!can_post)
      fake_params_redirect
      return
    end
    @post = Post.new(params[:post])
    @post.team = @team if @team
    if @training
      @post.training = @training
      @post.team_id = @training.team_id
    end
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
    @post = Post.find(params[:id])
    if !@post.can_be_modified_by?(current_user)
      fake_params_redirect
      return
    end
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
    team_id = @post.team_id
    if !@post.can_be_destroyed_by?(current_user)
      fake_params_redirect
      return
    end
    @post.destroy
    redirect_to team_posts_url(team_id)
  end

protected
  def can_post
    if (params[:team_id])
      @team = Team.find(params[:team_id])
      return current_user.is_team_member_of?(@team)
    elsif (params[:training_id])
      @training = Training.find(params[:training_id])
      return current_user.is_team_member_of?(@training.team_id)
    else
      false
    end
  end
end

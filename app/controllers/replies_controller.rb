class RepliesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    if (!@post.can_be_replied_by?(current_user))
      fake_params_redirect
      return
    end
    @reply = Reply.new(params[:reply])
    @reply.user = current_user
    @post.replies << @reply
    if @post.save
      redirect_to(@post)
    else
      @post.replies.reload
      @can_reply = @post.can_be_replied_by?(current_user)
      @team = @post.team
      @training = @post.training
      @related_posts = @team.posts.find(:all, :limit => 20) - [@post]
      render :template => "posts/show", :layout => "team_layout" 
    end
  end

  def destroy
    @reply = Reply.find(params[:id])
    if (!@reply.can_be_destroyed_by?(current_user))
      fake_params_redirect
    else      
      @reply.post.replies.delete(@reply)
      redirect_to @reply.post
    end
  end
end
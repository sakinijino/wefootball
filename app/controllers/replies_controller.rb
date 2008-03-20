class RepliesController < ApplicationController
  # POST posts/1/replies
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
      @team = @post.team
      @can_reply = @post.can_be_replied_by?(current_user)
      render :template => "posts/show", :layout=>'team_layout'
    end
  end

  # DELETE posts/1/replies/1
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

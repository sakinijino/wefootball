class RepliesController < ApplicationController
  # POST posts/1/replies
  def create
    @post = Post.find(params[:post_id])
    if (!current_user.is_team_member_of?(@post.team_id))
      fake_params_redirect
      return
    end
    @reply = @post.replies.build(params[:reply])
    @reply.user = current_user    
    if @post.save
      redirect_to(@post)
    else
      @post.replies.reload
      render :template => "posts/show"
    end
  end

  # DELETE posts/1/replies/1
  def destroy
    @reply = Reply.find(params[:id])
    if (!@reply.can_be_destroyed_by?(current_user))
      fake_params_redirect
    else      
      @post.replies.delete(@reply, :dependent => :destroy)
      redirect_to @reply.post
    end
  end
end

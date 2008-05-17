class RepliesController < ApplicationController
  before_filter :login_required
  
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
      redirect_to(post_path(@post))
    else
      @replies = @post.replies.paginate(:page => params[:page], :per_page => PostsController::REPLIES_PER_PAGE)
      @can_reply = @post.can_be_replied_by?(current_user)
      @team = @post.team
      @activity = @post.activity
      @related_posts = @post.related(logged_in? ? current_user : nil, :limit => 20)
      @title = @post.title
      render :template => "posts/show", :layout => post_layout(@post)
    end
  end

  def destroy
    @reply = Reply.find(params[:id])
    if (!@reply.can_be_destroyed_by?(current_user))
      fake_params_redirect
    else      
      @reply.post.replies.delete(@reply)
      redirect_to post_path(@reply.post)
    end
  end
  
protected  
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

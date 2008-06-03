class SiteRepliesController < ApplicationController
  def create
    @site_post = SitePost.find(params[:site_post_id])
    @reply = SiteReply.new(params[:reply])
    @reply.user = current_user if logged_in?
    @site_post.site_replies << @reply
    if @site_post.save
      redirect_to(@site_post)
    else
      @replies = @site_post.site_replies.paginate(:page => params[:page], :per_page => 100)
      render :template => "site_posts/show", :layout => "user_layout"
    end
  end

  def destroy
    @reply = SiteReply.find(params[:id])
    if (!@reply.can_be_destroyed_by?(current_user))
      fake_params_redirect
    else      
      @reply.site_post.site_replies.delete(@reply)
      redirect_to @reply.site_post
    end
  end
end

class SitePostsController < ApplicationController

  def index
    @site_posts = SitePost.paginate(:order => "updated_at desc", :page => params[:page], :per_page => 30)
    @title = "站务论坛"
    render :layout => "user_layout"
  end

  def show
    @site_post = SitePost.find(params[:id])
    @replies = @site_post.site_replies.paginate(:page => params[:page], :per_page => 100)
    render :layout => "user_layout"
  end

  def new
    @site_post = SitePost.new
    @title = "发言"
    render :layout => "user_layout"
  end

  def create
    @site_post = SitePost.new(params[:site_post])
    @site_post.user = current_user if logged_in?
    if @site_post.save
      redirect_to(@site_post)
    else
      @title = "发言"
      render :action => "new", :layout => "user_layout"
    end
  end

  def destroy
    @site_post = SitePost.find(params[:id])
    if !@site_post.can_be_destroyed_by?(current_user)
      fake_params_redirect
    else
      @site_post.destroy
      redirect_to(site_posts_url)
    end
  end
end

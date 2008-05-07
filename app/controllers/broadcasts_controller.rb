class BroadcastsController < ApplicationController
  before_filter :login_required
  
  def index
    @user = current_user
    @bcs = Broadcast.get_related_broadcasts(current_user, :page => params[:page], :per_page => 30)
    @title = "我的广播"
    render :layout => 'user_layout'
  end
end

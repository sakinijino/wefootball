class BroadcastsController < ApplicationController
  before_filter :login_required
  
  def index
    @bcs = Broadcast.get_related_broadcasts(current_user)
  end
end

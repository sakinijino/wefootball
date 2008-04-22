class FriendRelationsController < ApplicationController
  before_filter :login_required, :except => [:index]

  def index
    @user = User.find(params[:user_id], :conditions=>"activated_at is not null")
    @friendsList = @user.friends
    @title = "#{@user.nickname}的朋友"
    render :layout => 'user_layout'
  end

  def create
    @req = FriendInvitation.find(params[:request_id],:include=>[:applier])
    if(@req.host_id != current_user.id)
      fake_params_redirect
      return
    end
    
    if (FriendRelation.are_friends?(@req.applier_id, @req.host_id))
      FriendInvitation.delete(params[:request_id])
      redirect_to friend_invitations_path
      return
    end

    FriendRelation.transaction do
      @friend_relation = FriendRelation.new
      @friend_relation.user1_id = @req.applier_id
      @friend_relation.user2_id = @req.host_id
      @friend_relation.save!
      @req.destroy
    end
    redirect_with_back_uri_or_default friend_invitations_path
  end

  def destroy
    FriendRelation.destroy_all(["(user1_id = ? and user2_id = ?) or (user1_id = ? and user2_id = ?)", 
      current_user.id, params[:user_id], params[:user_id], current_user.id] )
    redirect_to user_view_path(params[:user_id])
  end
end

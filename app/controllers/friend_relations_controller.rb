class FriendRelationsController < ApplicationController
  before_filter :login_required
  # GET /friend_relations
  def index
    user_id = (params[:user_id]==nil) ? current_user.id : params[:user_id]
    @friendsList = User.find(user_id).friends
  end

  # POST /friend_relations
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
      @friend_relation.save
      FriendInvitation.delete(params[:request_id])
    end
    redirect_to friend_invitations_path
  end

  # DELETE /friend_relations/1
  # DELETE /friend_relations/1.xml
  def destroy
    FriendRelation.destroy_all(["(user1_id = ? and user2_id = ?) or (user1_id = ? and user2_id = ?)", 
      current_user.id, params[:user_id], params[:user_id], current_user.id] )
    redirect_to user_view_path(params[:user_id])
  end
end

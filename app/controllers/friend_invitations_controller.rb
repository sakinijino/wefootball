class FriendInvitationsController < ApplicationController
  layout "user_layout"
  
  before_filter :login_required
  def index
    #only return the invitations of current user
    @user = current_user
    @title = "希望和我成为朋友的用户"
    @friend_invitations = FriendInvitation.find_all_by_host_id(current_user.id,:include=>[:applier])
  end

  def create
    if(current_user.id.to_s == params[:friend_invitation][:host_id].to_s)
      fake_params_redirect
      return
    end    
    
    @applier = current_user
    @host = User.find(params[:friend_invitation][:host_id], :conditions=>"activated_at is not null")
    if (FriendRelation.are_friends?(current_user.id, @host.id))
      redirect_to user_view_path(@host.id)
      return
    end

    @friend_invitation = FriendInvitation.find_or_initialize_by_applier_id_and_host_id(
      current_user.id, @host.id)
    @friend_invitation.host = @host
    @friend_invitation.applier = @applier
    @friend_invitation.update_attributes!(params[:friend_invitation])
    redirect_to user_view_path(@host.id)
  end

  def destroy
    @friend_invitation = FriendInvitation.find(params[:id])
    if (@friend_invitation.host_id != current_user.id)
      redirect_to friend_invitations_path
      return
    end
    @friend_invitation.destroy
    @user = current_user
    redirect_with_back_uri_or_default friend_invitations_path
  end
end

class FriendInvitationsController < ApplicationController
  before_filter :login_required
  # GET /friend_invitations
  # GET /friend_invitations.xml
  def index
    #only return the quests for current user
    @friend_invitations = FriendInvitation.find_all_by_host_id(current_user.id,:include=>[:applier])
  end
  
  # render new.rhtml
  def new
    @host_id = params[:host_id]
  end 

  # POST /friend_invitations
  # POST /friend_invitations.xml
  def create
    @applier = current_user
    @host = User.find(params[:friend_invitation][:host_id])
    if (FriendRelation.are_friends?(current_user.id, params[:friend_invitation][:host_id]))
      redirect_to user_path(@host.id)
      return
    end
    if(current_user.id.to_s == params[:friend_invitation][:host_id].to_s)
      fake_params_redirect
      return
    end

    @friend_invitation = FriendInvitation.find_or_initialize_by_applier_id_and_host_id(
      current_user.id, params[:friend_invitation][:host_id])
    @friend_invitation.host = @host
    @friend_invitation.applier = @applier
    if @friend_invitation.update_attributes(params[:friend_invitation])
      redirect_to user_view_path(@host.id)
    else
      fake_params_redirect
    end
  end

  # DELETE /friend_invitations/1
  # DELETE /friend_invitations/1.xml
  def destroy
    @friend_invitation = FriendInvitation.find(params[:id])
    if (@friend_invitation.host_id != current_user.id)
      redirect_to friend_invitations_path
      return
    end
    @friend_invitation.destroy
    redirect_to friend_invitations_path
  end
end
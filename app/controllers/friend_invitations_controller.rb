class FriendInvitationsController < ApplicationController
  before_filter :login_required
  # GET /friend_invitations
  # GET /friend_invitations.xml
  def index
    #only return the quests for current user
    @friend_invitations = FriendInvitation.find_all_by_host_id(current_user.id,:include=>[:applier])
    respond_to do |format|
      format.xml  {render :status => 200}
    end
  end

  # POST /friend_invitations
  # POST /friend_invitations.xml
  def create
    @applier = current_user
    @host = User.find(params[:friend_invitation][:host_id])
    if (FriendRelation.are_friends?(current_user.id, params[:friend_invitation][:host_id]))
      head 400
      return
    end
    if(current_user.id.to_s == params[:friend_invitation][:host_id].to_s)
      head 400
      return
    end
    
    @friend_invitation = FriendInvitation.find_by_applier_id_and_host_id(
      current_user.id, params[:friend_invitation][:host_id])
    
    if (@friend_invitation==nil)
      params[:friend_invitation][:applier_id] = current_user.id.to_s
      @friend_invitation = FriendInvitation.new(params[:friend_invitation])
      respond_to do |format|
        if @friend_invitation.save
          format.xml  { render :status=>200}
        else
          format.xml  { render :xml => @friend_invitation.errors.to_xml_full, :status => 200 }
        end
      end
    else
      respond_to do |format|
        if @friend_invitation.update_attributes(params[:friend_invitation])
          format.xml  { render :status=>200}
        else
          format.xml  { render :xml => @friend_invitation.errors.to_xml_full, :status => 200 }
        end
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end

  # DELETE /friend_invitations/1
  # DELETE /friend_invitations/1.xml
  def destroy
    @friend_invitation = FriendInvitation.find(params[:id])
    if (@friend_invitation.host_id != current_user.id)
      head 401
      return
    end
    @friend_invitation.destroy
    respond_to do |format|
      format.xml  { head :ok }
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
  
  # GET /friend_invitations/count.xml
  def count
    countNumber = FriendInvitation.count(:conditions=>["host_id = ?",current_user.id])
    s = "<count>" + countNumber.to_s + "</count>"
    puts s
    respond_to do |format|
      format.xml  { render :xml => s }
    end
  end  
end

class FriendRelationsController < ApplicationController
  before_filter :login_required
  # GET /friend_relations
  # GET /friend_relations.xml
  def index
    @friendsList = User.find_by_id(params[:user_id]).friends

    respond_to do |format|
      format.xml  { render :status=>200}   
    end
  end

  # POST /friend_relations
  # POST /friend_relations.xml
  def create
    @req = PreFriendRelation.find(params[:request_id],:include=>[:applier])    
    
    if (FriendRelation.are_friends?(@req.applier_id, @req.host_id))
      PreFriendRelation.delete(params[:request_id])
      head 200
      return
    end
    
    if(@req.host_id != current_user.id)
      head 401
      return
    end

    @friend_relation = FriendRelation.new
    @friend_relation.user1_id = @req.applier_id
    @friend_relation.user2_id = @req.host_id
    if @friend_relation.save
      PreFriendRelation.delete(params[:request_id])
      respond_to do |format|
        format.xml {render :status => 200}
      end
    else
      respond_to do |format|
        format.xml  { render :xml => @friend_relation.errors.to_xml_full, :status => 200 }
      end
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.xml { head 404 }
    end
  end

  # DELETE /friend_relations/1
  # DELETE /friend_relations/1.xml
  def destroy
    FriendRelation.destroy_all(["(user1_id = ? and user2_id = ?) or (user1_id = ? and user2_id = ?)", 
      current_user.id, params[:user_id], params[:user_id], current_user.id] )
    respond_to do |format|
      format.xml  { head :ok }
    end
  end
end

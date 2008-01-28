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
    @request = PreFriendRelation.find(params[:request_id],:include=>[:applier])    
    
    if(@request.host_id != current_user.id)
      head 401
      return
    end

    @friend_relation = FriendRelation.new
    @friend_relation.user1_id = @request.applier_id
    @friend_relation.user2_id = @request.host_id
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
    @friend_relation = FriendRelation.find(params[:id])
    if(@friend_relation.user1_id != current_user.id && @friend_relation.user2_id != current_user.id)
      head 401
      return
    end
    @friend_relation.destroy
    respond_to do |format|
      format.xml  { head :ok }
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.xml { head 404 }
    end
  end
end

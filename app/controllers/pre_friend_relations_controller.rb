class PreFriendRelationsController < ApplicationController
  before_filter :login_required
  # GET /pre_friend_relations
  # GET /pre_friend_relations.xml
  def index
    #only return the quests for current user
    @pre_friend_relations = PreFriendRelation.find_all_by_host_id(current_user.id,:include=>[:applier])
    respond_to do |format|
      format.xml  {render :status => 200}
    end
  end

  # POST /pre_friend_relations
  # POST /pre_friend_relations.xml
  def create
    @applier = User.find(params[:pre_friend_relation][:applier_id])
    @host = User.find(params[:pre_friend_relation][:host_id])
    if(params[:pre_friend_relation][:applier_id] == params[:pre_friend_relation][:host_id])
      head 400
      return
    end
    if(params[:pre_friend_relation][:applier_id] != current_user.id)
      head 401
      return
    end
    @pre_friend_relation = PreFriendRelation.new(params[:pre_friend_relation])
    respond_to do |format|
      if @pre_friend_relation.save
        format.xml  { render :status=>200}
      else
        format.xml  { render :xml => @pre_friend_relation.errors.to_xml_full, :status => 200 }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end

  # DELETE /pre_friend_relations/1
  # DELETE /pre_friend_relations/1.xml
  def destroy
    @pre_friend_relation = PreFriendRelation.find(params[:id])
    if (@pre_friend_relation.host_id != current_user.id)
      head 401
      return
    end
    @pre_friend_relation.destroy
    respond_to do |format|
      format.xml  { head :ok }
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
  
  # GET /pre_friend_relations/count.xml
  def count
    countNumber = PreFriendRelation.count(:conditions=>["host_id = ?",current_user.id])
    s = "<count>" + countNumber.to_s + "</count>"
    puts s
    respond_to do |format|
      format.xml  { render :xml => s }
    end
  end  
end

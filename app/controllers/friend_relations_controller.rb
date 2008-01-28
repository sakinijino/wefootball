class FriendRelationsController < ApplicationController
  # GET /friend_relations
  # GET /friend_relations.xml
  def index 
    @friendsList = User.find_by_id(params[:user_id]).friends

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :status=>200}   
    end
  end

  # GET /friend_relations/1
  # GET /friend_relations/1.xml
  def show
    @friend_relation = FriendRelation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @friend_relation.to_xml(:dasherize=>false) }
    end
  end

  # GET /friend_relations/new
  # GET /friend_relations/new.xml
  def new
    @friend_relation = FriendRelation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @friend_relation.to_xml(:dasherize=>false) }
    end
  end

  # GET /friend_relations/1/edit
  def edit
    @friend_relation = FriendRelation.find(params[:id])
  end

  # POST /friend_relations
  # POST /friend_relations.xml
  def create
    @request = PreFriendRelation.find(params[:request_id],:include=>[:applier])    
    
    if(@request.applier_id != current_user.id)
      head 401
      return
    end

    @friend_relation = FriendRelation.new
    @friend_relation.user1_id = @request.applier_id
    @friend_relation.user2_id = @request.host_id
    if @friend_relation.save!
      PreFriendRelation.delete(params[:request_id])
    end

    respond_to do |format|
      #~ @short_format = true
      format.xml {render :status => 200}
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.xml { render :xml => @friend_relation.errors.to_xml_full}
    end
  end

  # PUT /friend_relations/1
  # PUT /friend_relations/1.xml
  def update
    @friend_relation = FriendRelation.find(params[:id])

    respond_to do |format|
      if @friend_relation.update_attributes(params[:friend_relation])
        flash[:notice] = 'FriendRelation was successfully updated.'
        format.html { redirect_to(@friend_relation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @friend_relation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /friend_relations/1
  # DELETE /friend_relations/1.xml
  def destroy
    @friend_relation = FriendRelation.find(params[:id])
    @friend_relation.destroy

    respond_to do |format|
      format.html { redirect_to(friend_relations_url) }
      format.xml  { head :ok }
    end
  end

end

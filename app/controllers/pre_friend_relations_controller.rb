class PreFriendRelationsController < ApplicationController
  # GET /pre_friend_relations
  # GET /pre_friend_relations.xml
  def index
    #only return the quests for current user
    @pre_friend_relations = PreFriendRelation.find_all_by_host_id(current_user.id,:include=>[:applier])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  {render :status => 200}
    end
  end

  # GET /pre_friend_relations/1
  # GET /pre_friend_relations/1.xml
  def show
    @pre_friend_relation = PreFriendRelation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pre_friend_relation.to_xml(:dasherize=>false) }
    end
  end

  # GET /pre_friend_relations/new
  # GET /pre_friend_relations/new.xml
  def new
    @pre_friend_relation = PreFriendRelation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pre_friend_relation.to_xml(:dasherize=>false) }
    end
  end

  # GET /pre_friend_relations/1/edit
  def edit
    @pre_friend_relation = PreFriendRelation.find(params[:id])
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
    
    @pre_friend_relation = PreFriendRelation.new(params[:pre_friend_relation])
    respond_to do |format|
      if @pre_friend_relation.save
        flash[:notice] = 'PreFriendRelation was successfully created.'
        format.html { redirect_to(@pre_friend_relation) }
        format.xml  { render :status=>200}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pre_friend_relation.errors.to_xml_full, :status => 200 }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end     
  end

  # PUT /pre_friend_relations/1
  # PUT /pre_friend_relations/1.xml
  def update
    @pre_friend_relation = PreFriendRelation.find(params[:id])

    respond_to do |format|
      if @pre_friend_relation.update_attributes(params[:pre_friend_relation])
        flash[:notice] = 'PreFriendRelation was successfully updated.'
        format.html { redirect_to(@pre_friend_relation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pre_friend_relation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pre_friend_relations/1
  # DELETE /pre_friend_relations/1.xml
  def destroy
    @pre_friend_relation = PreFriendRelation.find(params[:id])
    @pre_friend_relation.destroy

    respond_to do |format|
      format.html { redirect_to(pre_friend_relations_url) }
      format.xml  { head :ok }
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

class FriendRelationsController < ApplicationController
  # GET /friend_relations
  # GET /friend_relations.xml
  def index 
    friendsList = User.find_by_id(params[:user_id]).friends

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => friendsList.to_xml(
                           :only=>[:id,:nickname],:dasherize=>false)}   
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
    @friend_relation = FriendRelation.new(params[:friend_relation])
    PreFriendRelation.delete(params[:pre_id])

    respond_to do |format|
      if @friend_relation.save
        flash[:notice] = 'FriendRelation was successfully created.'
        format.html { redirect_to(@friend_relation) }
        format.xml  { render :xml => @friend_relation.to_xml(:dasherize=>false), :status => :ok, :location => @friend_relation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @friend_relation.errors, :status => :unprocessable_entity }
      end
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

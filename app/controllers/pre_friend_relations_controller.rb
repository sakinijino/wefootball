class PreFriendRelationsController < ApplicationController
  # GET /pre_friend_relations
  # GET /pre_friend_relations.xml
  def index
    @pre_friend_relations = PreFriendRelation.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pre_friend_relations }
    end
  end

  # GET /pre_friend_relations/1
  # GET /pre_friend_relations/1.xml
  def show
    @pre_friend_relation = PreFriendRelation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pre_friend_relation }
    end
  end

  # GET /pre_friend_relations/new
  # GET /pre_friend_relations/new.xml
  def new
    @pre_friend_relation = PreFriendRelation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pre_friend_relation }
    end
  end

  # GET /pre_friend_relations/1/edit
  def edit
    @pre_friend_relation = PreFriendRelation.find(params[:id])
  end

  # POST /pre_friend_relations
  # POST /pre_friend_relations.xml
  def create
    params[:pre_friend_relation]["apply_date"] = Date.today
    @pre_friend_relation = PreFriendRelation.new(params[:pre_friend_relation])

    respond_to do |format|
      if @pre_friend_relation.save
        flash[:notice] = 'PreFriendRelation was successfully created.'
        format.html { redirect_to(@pre_friend_relation) }
        format.xml  { render :xml => @pre_friend_relation, 
                              :status => :ok, :location => @pre_friend_relation}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pre_friend_relation.errors, :status => :unprocessable_entity }
      end
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
end

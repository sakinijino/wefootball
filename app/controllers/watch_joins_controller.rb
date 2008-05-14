class WatchJoinsController < ApplicationController
  # GET /watch_joins
  # GET /watch_joins.xml
  def index
    @watch_joins = WatchJoin.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @watch_joins }
    end
  end

  # GET /watch_joins/1
  # GET /watch_joins/1.xml
  def show
    @watch_join = WatchJoin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @watch_join }
    end
  end

  # GET /watch_joins/new
  # GET /watch_joins/new.xml
  def new
    @watch_join = WatchJoin.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @watch_join }
    end
  end

  # GET /watch_joins/1/edit
  def edit
    @watch_join = WatchJoin.find(params[:id])
  end

  # POST /watch_joins
  # POST /watch_joins.xml
  def create
    @watch_join = WatchJoin.new(params[:watch_join])

    respond_to do |format|
      if @watch_join.save
        flash[:notice] = 'WatchJoin was successfully created.'
        format.html { redirect_to(@watch_join) }
        format.xml  { render :xml => @watch_join, :status => :created, :location => @watch_join }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @watch_join.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /watch_joins/1
  # PUT /watch_joins/1.xml
  def update
    @watch_join = WatchJoin.find(params[:id])

    respond_to do |format|
      if @watch_join.update_attributes(params[:watch_join])
        flash[:notice] = 'WatchJoin was successfully updated.'
        format.html { redirect_to(@watch_join) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @watch_join.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /watch_joins/1
  # DELETE /watch_joins/1.xml
  def destroy
    @watch_join = WatchJoin.find(params[:id])
    @watch_join.destroy

    respond_to do |format|
      format.html { redirect_to(watch_joins_url) }
      format.xml  { head :ok }
    end
  end
end

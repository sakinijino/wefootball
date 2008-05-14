class WatchesController < ApplicationController

  def index
    @watches = Watch.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @watches }
    end
  end

  
  
  def show
    @watch = Watch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @watch }
    end
  end

  

  def new
    @watch = Watch.new
  end

  
  
  def edit
    @watch = Watch.find(params[:id])
  end


  
  def create
    #查一下official_match是否存在
    #是否要保护属性
    #建立match_join类
    @watch = Watch.new(params[:watch])

    Watch.transaction do
      @watch.save! 
      WatchJoin.create!(:watch_id=>@watch.id,:user_id=>current_user.id)    
      redirect_to watch_path(@watch)
    end
    rescue ActiveRecord::RecordInvalid => e
      render :action => 'new' 
  end
  
  
  
  def update
    @watch = Watch.find(params[:id])

    respond_to do |format|
      if @watch.update_attributes(params[:watch])
        flash[:notice] = 'Watch was successfully updated.'
        format.html { redirect_to(@watch) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @watch.errors, :status => :unprocessable_entity }
      end
    end
  end


  
  def destroy
    @watch = Watch.find(params[:id])
    @watch.destroy

    respond_to do |format|
      format.html { redirect_to(watches_url) }
      format.xml  { head :ok }
    end
  end
end

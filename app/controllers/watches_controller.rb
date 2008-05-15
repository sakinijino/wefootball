class WatchesController < ApplicationController
  before_filter :login_required, :except => [:show]  
  
  def show
    @watch = Watch.find(params[:id])
    @official_match = @watch.official_match
    @is_admin = logged_in? && (@watch.admin.id == current_user.id)
    @title = "#{@watch.start_time}去#{@watch.location}看球"
    render :layout => default_layout
  end


  
  def new
    @watch = Watch.new
    @official_match = OfficialMatch.find(params[:watch][:official_match_id])    
    @watch.start_time = Time.now
    @title = "观看#{@official_match.start_time}#{@official_match.host_team.name}对阵#{@official_match.guest_team.name}的比赛"
    render :layout => default_layout    
  end


  
  def create 
    @official_match = OfficialMatch.find(params[:watch][:official_match_id])   
    @watch = Watch.new(params[:watch])
    @watch.official_match = @official_match
    @watch.admin = current_user    

    Watch.transaction do
      @watch.save! 
      WatchJoin.create!(:watch_id=>@watch.id,:user_id=>current_user.id)    
      redirect_to watch_path(@watch)
    end
    rescue ActiveRecord::RecordInvalid => e
      render :action => 'new', :layout => default_layout 
  end

  
  
  def edit
    @watch = Watch.find(params[:id])    
    if @watch.admin.id != current_user.id    
      fake_params_redirect
      return
    end
    @official_match = @watch.official_match
    @title = "观看#{@official_match.start_time}#{@official_match.host_team.name}对阵#{@official_match.guest_team.name}的比赛"    
  end
  
  
  
  def update
    @watch = Watch.find(params[:id])
    if @watch.admin.id != current_user.id    
      fake_params_redirect
      return
    end
    if @watch.update_attributes(params[:watch])   
      redirect_to(watch_path(@watch))
    else
      render :action => "edit"      
    end
  end


  
  def destroy
    @watch = Watch.find(params[:id])    
    fake_params_redirect if @watch.admin.id != current_user.id     
    @watch.destroy
    redirect_to official_match_path(@watch.official_match_id)
  end
end

class PlaysController < ApplicationController
  before_filter :parse_time, :only => [:create]
  before_filter :login_required, :only=>[:new,:create]
  

  def show
    @play = Play.find(params[:id])
    @title = "去 #{@play.location} 随便踢踢"
    @user = current_user 
    render :layout => "user_layout"    
  end

  def new
    @play = Play.new
    @default_start_time = 1.hour.since
    @default_end_time = @default_start_time.since(3600)
    @title = "去随便踢踢"    
    @user = current_user
    render :layout => "user_layout"
  end

  def create
    Play.transaction do
      @play = Play.create!(params[:play])   
      PlayJoin.create!(:play_id=>@play.id,:user_id=>current_user.id)    
      redirect_to play_path(@play)
    end
    rescue ActiveRecord::RecordInvalid => e
      @play = Play.new
      @default_start_time = 1.hour.since
      @default_end_time = 2.hours.since
      @user = current_user
      render :action => 'new', :layout => "user_layout"   
  end
  
 private
  def parse_time
    return if !params[:start_time] || !params[:end_time]
    params[:play] = {} if !params[:play]
    params[:play]["start_time(1i)"] = params[:start_time][:year]
    params[:play]["start_time(2i)"] = params[:start_time][:month]
    params[:play]["start_time(3i)"] = params[:start_time][:day]
    params[:play]["start_time(4i)"] = params[:start_time][:hour]
    params[:play]["start_time(5i)"] = params[:start_time][:minute]
    params[:play]["end_time(1i)"] = params[:start_time][:year]
    params[:play]["end_time(2i)"] = params[:start_time][:month]
    params[:play]["end_time(3i)"] = params[:start_time][:day]
    params[:play]["end_time(4i)"] = params[:end_time][:hour]
    params[:play]["end_time(5i)"] = params[:end_time][:minute]
  end  
end

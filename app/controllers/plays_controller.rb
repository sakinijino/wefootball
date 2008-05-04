class PlaysController < ApplicationController
  before_filter :parse_time, :only => [:create]
  before_filter :login_required, :only=>[:new,:create]

  PLAYER_LIST_LENGTH = 18  

  def show
    @play = Play.find(params[:id])
    @players = @play.users.find(:all,:limit=>PLAYER_LIST_LENGTH+1)
    render :layout => default_layout  
  end

  def players
    @play = Play.find(params[:id])    
    @title = "#{@play.start_time.strftime('%Y-%m-%d %H:%M')}-#{@play.end_time.strftime('%H:%M')}, 在#{@play.location}一起踢球的人"
    @players = @play.users.paginate(:page => params[:page], :per_page => 100)
    render :layout => default_layout    
  end
  
  def new
    @play = Play.new
    @play.start_time = 1.hour.since #默认开始和结束时间
    @play.end_time = @play.start_time.since(3600)
    @title = "去随便踢踢"
    @user = current_user
    render :layout => "user_layout"
  end

  def create
    @play = Play.new(params[:play])
    Play.transaction do
      @play.save! 
      PlayJoin.create!(:play_id=>@play.id,:user_id=>current_user.id)    
      redirect_to play_path(@play)
    end
    rescue ActiveRecord::RecordInvalid => e
      @user = current_user
      @title = "去随便踢踢"
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

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  before_filter :store_current_location
  
  filter_parameter_logging "password"
  
  helper :all # include all helpers, all the time
  include AuthenticatedSystem
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # TODO - this will be uncommented once we explain sessions
  # in iteration 5.
  # protect_from_forgery
  # :secret => 'dd92c128b5358a710545b5e755694d57'
  
  
  def index
    @users = User.find(:all, :conditions=>"activated_at is not null", :limit => 9, :order => 'id desc')
    @teams = Team.find(:all, :limit => 9, :order => 'id desc')
    
    tmp = []
    tmp += Training.find(:all, :limit => 1, :conditions => ['end_time > ?', Time.now], :order=>'start_time')
    tmp += Match.find(:all, :limit => 1, :conditions => ['end_time > ?', Time.now], :order=>'start_time')
    tmp += SidedMatch.find(:all, :limit => 1, :conditions => ['end_time > ?', Time.now], :order=>'start_time')
    tmp += Play.find(:all, :limit => 1, :conditions => ['end_time > ?', Time.now], :order=>'start_time')
    tmp += Watch.find(:all, :limit => 1, :conditions => ['end_time > ?', Time.now], :order=>'start_time')
    tmp = tmp.sort_by{|act| act.start_time}
    if (tmp.length >0)
      @start_time = tmp[0].start_time.yesterday
      @end_time = tmp[-1].end_time.tomorrow
      @activities = tmp.group_by{|t| t.start_time.strftime("%Y-%m-%d")}
    else
      @start_time = Time.now
      @end_time = Time.now
      @activities = {}
    end
    
    @bcs = Broadcast.find(:all, :limit => 5*2, :order => 'id desc')
    @bcs = @bcs.reject do |item| 
      (((item.class == FriendCreationBroadcast) && (item.user_id < item.friend_id)) ||
      ((item.class == MatchCreationBroadcast) && (item.team_id == item.match.guest_team_id)))
    end
    @bcs = @bcs.slice(0,5)
    
    @official_matches = OfficialMatch.paginate :conditions => ['end_time > ? and start_time < ?', Time.now, 7.days.since],
      :order=>'watch_join_count DESC, start_time',
      :page => params[:page],
      :per_page => 3
    render :template => 'shared/index', :layout =>default_layout
  end
  
  def about
    render :template => 'shared/about', :layout =>default_layout
  end
  
  def faq
    render :template => 'shared/faq', :layout =>default_layout
  end
  
  
  class FakeParametersError < StandardError
  end
  
protected
  def store_current_location #记录页面位置，登录后跳转回该页面
    store_location if !logged_in? && request.get?
  end
  
  def clear_store_location
    session[:return_to] = nil
  end
  
  def default_layout
    if logged_in?
      @user = current_user
      "user_layout"
    else
      "unlogin_layout"
    end
  end
  
  def fake_params_redirect
    #redirect_to '/'
    head 403
  end
  
  def redirect_with_back_uri_or_default(uri='/')
    params[:back_uri]!=nil ? redirect_to(params[:back_uri]) : redirect_to(uri)
  end
end

WillPaginate::ViewHelpers.pagination_options[:prev_label] = '< 前页'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '后页 >'
WillPaginate::ViewHelpers.pagination_options[:inner_window] = 2
WillPaginate::ViewHelpers.pagination_options[:outer_window] = 1

class DateTime
  def self.today
    DateTime.now.at_midnight
  end
end

class Time
  def self.today
    Time.now.at_midnight
  end
end

class ActionView::Helpers::FormBuilder
  def province_city_select(field, selectedCity = nil)
    "<span id='#{@object_name}-province-city-selected-#{selectedCity ? selectedCity : @object[field]}' class='province_city_select'>#{
       select field, ProvinceCity::TOP_LIST.keys.sort.map {|v| [ProvinceCity::LIST[v], v]}}&nbsp;&nbsp;#{
       select field, []}</span>"
  end
  def football_ground_select(field, selectedFootballGround = nil, selectedCity = nil)
    "<span id='#{@object_name}-football-ground-selected-#{selectedFootballGround ? selectedFootballGround : @object[field]}' class='football_ground_select'>#{
      province_city_select(field, selectedCity ? selectedCity : '')}&nbsp;&nbsp;#{
      select field, []}&nbsp;&nbsp;</span>"
  end
end

module ActiveRecord
  class Errors
    def full_messages
      full_messages = []
      
      @errors.each_key do |attr|
        @errors[attr].each do |msg|
          next if msg.nil?
          full_messages << msg
        end
      end
      full_messages
    end
  end
end
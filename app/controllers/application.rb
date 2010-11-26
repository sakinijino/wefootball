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
    
  class FakeParametersError < StandardError
  end
  
protected
  def store_current_location #记录页面位置，登录后跳转回该页面
    store_location if !logged_in? && request.get?
  end
  
  def clear_store_location
    session[:return_to] = nil
  end
  
  def fake_params_redirect
    # ugly trick
    # think about gentle solution to fix it
    if RAILS_ENV == 'production'
      render_403
    else 
      head 403
    end
  end
  
  def redirect_with_back_uri_or_default(uri='/')
    params[:back_uri]!=nil ? redirect_to(params[:back_uri]) : redirect_to(uri)
  end

  def render_403
    render :file => "\#{RAILS_ROOT}/public/403.html", :status => 403
  end
end

if defined? WillPaginate
  WillPaginate::ViewHelpers.pagination_options[:prev_label] = '< 前页'
  WillPaginate::ViewHelpers.pagination_options[:next_label] = '后页 >'
  WillPaginate::ViewHelpers.pagination_options[:inner_window] = 2
  WillPaginate::ViewHelpers.pagination_options[:outer_window] = 1
end

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

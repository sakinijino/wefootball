# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # TODO - this will be uncommented once we explain sessions
  # in iteration 5.
  # protect_from_forgery
  # :secret => 'dd92c128b5358a710545b5e755694d57' 
  def fake_params_redirect
    redirect_to '/'
  end
  
  def redirect_with_back_uri_or_default(uri='/')
    params[:back_uri]!=nil ? redirect_to(params[:back_uri]) : redirect_to(uri)
  end
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
  def province_city_select(field)
    select field, ProvinceCity::CITY_VALUE_RANGE.map {|v| [ProvinceCity::LIST[v], v]}
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
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

module ActiveRecord #:nodoc:
  class Errors #:nodoc:
    def to_xml_full(options={})
      options[:root] ||= "errors"
      options[:indent] ||= 2
      options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
      options[:builder].instruct! unless options.delete(:skip_instruct)
      options[:builder].errors do |e|
        # The @errors instance variable is a Hash inside the
        # Errors class
        @errors.each_key do |attr|
          @errors[attr].each do |msg|
            next if msg.nil?
            if attr == "base"
              options[:builder].error("message"=>msg)
            else
              fullmsg = @base.class.human_attribute_name(attr) + " " + msg
              options[:builder].error("field"=>attr, "message"=>fullmsg)
            end
          end
        end
      end
    end
  end
end

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!({:flex=>"%m/%d/%Y"})
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!({:flex=>"%a, %d %b %Y %H:%M:%S %z"})
ActiveSupport::CoreExtensions::Hash::Conversions::XML_FORMATTING.merge!({
  "date"     => Proc.new { |date| date.to_s(:flex) },
  "datetime" => Proc.new { |time| time.to_s(:flex) }
})

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # TODO - this will be uncommented once we explain sessions
  # in iteration 5.
  # protect_from_forgery
  # :secret => 'dd92c128b5358a710545b5e755694d57'
  
  def access_denied
    respond_to do |format|
      format.xml {head 401}
    end
  end
  
    def default_user_to_xml_options
      {
        :dasherize=>false,
        :except=>[:crypted_password, :salt, :created_at, :updated_at, :remember_token, :remember_token_expires_at],
        :include => [:positions]
      }
    end
end
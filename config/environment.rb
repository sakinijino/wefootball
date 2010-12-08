# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

HOST = 'http://localhost:3000'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  config.load_paths += 
    %W( #{RAILS_ROOT}/app/modules #{RAILS_ROOT}/app/models/broadcasts #{RAILS_ROOT}/app/models/posts #{RAILS_ROOT}/app/models/match_reviews #{RAILS_ROOT}/app/sweepers #{RAILS_ROOT}/app/observers)

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_wefootball_session',
    :secret      => '48bcdcc8a2668121ebddc74fee24b0d3fad2508d9eb4caafeb2d425a645b1e7a0e407048eb8481ab2652ffdff642f833124dfa3ed33738024cf3e91854d5d310'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  #  config.active_record.observers = :user_observer, :user_team_observer
  config.active_record.observers = :user_team_observer, :friend_relation_observer,
    :match_join_observer, :match_observer,
    :play_join_observer, :sided_match_join_observer,
    :sided_match_observer, :training_join_observer, :training_observer,
    :watch_join_observer, :match_review_observer, :match_review_recommendation_observer

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  config.gem 'mini_magick', :version => '1.2.3'
  config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'
  config.gem 'icalendar', :version => '~> 1.1.0'

  #config.time_zone = "Beijing"
end

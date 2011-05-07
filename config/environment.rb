# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::VendorGemSourceIndex.silence_spec_warnings = true

# Authorization plugin for role based access control
# You can override default authorization system constants here.

# Can be 'object roles' or 'hardwired'
AUTHORIZATION_MIXIN = "object roles"

# NOTE : If you use modular controllers like '/admin/products' be sure
# to redirect to something like '/sessions' controller (with a leading slash)
# as shown in the example below or you will not get redirected properly
#
# This can be set to a hash or to an explicit path like '/login'
#
LOGIN_REQUIRED_REDIRECTION = { :controller => '/user_sessions', :action => 'new' }
PERMISSION_DENIED_REDIRECTION = { :controller => 'site', :action => 'home' }

# The method your auth scheme uses to store the location to redirect back to
STORE_LOCATION_METHOD = :store_location

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Login, authorisation, registration, etc...
  config.gem 'authlogic'
  config.gem 'oauth'
  config.gem 'authlogic-oauth', :lib => 'authlogic_oauth'
  config.gem 'facebooker'

  # Extras
  config.gem 'mislav-will_paginate', :lib => 'will_paginate',  :source => 'http://gems.github.com'
  config.gem 'settingslogic', :lib => 'settingslogic'
  config.gem 'juggernaut', :lib => 'juggernaut'
  config.gem 'javan-whenever', :lib => false, :source => 'http://gems.github.com'
  config.gem 'chronic'
  config.gem 'daemons'
  #config.gem 'aws-s3', :lib => 'aws/s3'
  #config.gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'
  #config.gem 'base62', :lib => 'base62', :source => 'http://gems.github.com'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

require 'json'

# To make Authlogic work in the console
# See http://github.com/jrallison/authlogic_oauth/issuesearch?state=open&q=nil.params#issue/2
require 'authlogic_oauth_hacks.rb'

# For Twitter https support
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

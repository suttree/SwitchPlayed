# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_arg_session',
  :secret      => '87dbcc341e3972a59e8335d462cc12d7e5d49716d56f20a5d70656fa585b2955c4215f685081d4efe73f46781ce3615557cf28e3025fcd7609ae1c4777332f63'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store

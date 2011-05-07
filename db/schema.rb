# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091012091555) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "game_id",    :null => false
    t.string   "session_id", :null => false
    t.string   "status",     :null => false
    t.string   "remote_ip",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["user_id", "status"], :name => "index_activities_on_user_id_and_status"

  create_table "bets", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "game_id",    :null => false
    t.float    "amount",     :null => false
    t.string   "period",     :null => false
    t.string   "remote_ip",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.string   "pip",        :limit => 5,                      :null => false
    t.string   "home_team",                                    :null => false
    t.string   "away_team",                                    :null => false
    t.datetime "start_time",                                   :null => false
    t.datetime "end_time",                                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "score",                   :default => "0 - 0"
  end

  add_index "games", ["pip"], :name => "index_games_on_pip"

  create_table "logged_exceptions", :force => true do |t|
    t.string   "exception_class"
    t.string   "controller_name"
    t.string   "action_name"
    t.text     "message"
    t.text     "backtrace"
    t.text     "environment"
    t.text     "request"
    t.datetime "created_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", :force => true do |t|
    t.integer  "game_id",                     :null => false
    t.string   "home_team",  :default => "0", :null => false
    t.string   "away_team",  :default => "0", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "transactions", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "amount",     :null => false
    t.string   "status",     :null => false
    t.integer  "game_id"
    t.string   "session_id"
    t.string   "remote_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["user_id", "status"], :name => "index_transactions_on_user_id_and_status"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                                 :null => false
    t.string   "single_access_token"
    t.string   "perishable_token",                                  :null => false
    t.integer  "login_count",                      :default => 0,   :null => false
    t.integer  "failed_login_count",               :default => 0,   :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.string   "twitter_name"
    t.string   "twitter_screen_name"
    t.string   "signup_source"
    t.string   "facebook_name"
    t.integer  "facebook_uid",        :limit => 8
    t.float    "balance",                          :default => 0.0, :null => false
  end

  add_index "users", ["oauth_token"], :name => "index_users_on_oauth_token"

end

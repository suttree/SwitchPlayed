#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end

timestamp = Time.now
last_timestamp = Time.now

# Debit the account of every active participant in the game chat room each minute
while($running) do
  ActiveRecord::Base.logger.info "[debitor] Starting debitor"
  if Game.in_progress?
    Activity.all_chatroom_members.each do |row|
      ActiveRecord::Base.logger.info "[debitor] Checking #{row.user.name} - #{row.user.id}"
      unless Activity.user_quit_chat?(row.user.id, last_timestamp)
        # remote_ip, game_id and session_id could be wrong here :(
        row.user.charge_for_chatroom_access(:remote_ip => row.remote_ip, :game_id => row.game_id, :session_id => row.session_id)
        ActiveRecord::Base.logger.info "[debitor] Charging #{row.user.name} for chatroom access"
      end
    end
  end
  
  last_timestamp = timestamp
  timestamp = Time.now

  ActiveRecord::Base.logger.info "[debitor] This daemon is still running at #{Time.now}."
  sleep 60
end

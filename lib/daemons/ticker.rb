#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end

the_time = nil
last_time = nil

# Post a timestamp to the game chat room every minute
while($running) do
  if Game.in_progress?
    the_time = Time.now.to_s(:time_without_seconds)
    str = "try {Element.insert(\"chat_data\", { top: \"<span class='robot'><li>#{the_time}</li></span>\" });} catch (e) { alert('RJS error:' + e.toString()); alert('Element.insert(\"chat_data\", { top: \"<li>#{the_time}</li>\" });'); throw e }"
    Juggernaut.send_to_all(str) unless the_time == last_time
    last_time = the_time
  end
  
  ActiveRecord::Base.logger.info "[ticker] This daemon is still running at #{Time.now}.\n"
  sleep 60
end

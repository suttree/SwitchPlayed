class ChatController < ApplicationController
  juggernaut_actions = [ :juggernaut_subscription, :juggernaut_connection_logout, :juggernaut_logout ]
  before_filter :require_user, :except => juggernaut_actions
  before_filter :check_juggernaut_params, :only => juggernaut_actions
  before_filter :setup_game_and_user, :only => juggernaut_actions

  protect_from_forgery :except => juggernaut_actions

  def send_data
    render :juggernaut do |page|
      page.insert_html :top, 'chat_data', "<li><b>#{h current_user.name}</b>&nbsp;&nbsp;#{h params[:chat_input]}<span class='time'>#{h Time.now.to_s(:time_with_seconds)}</span></li>"
    end
    render :nothing => true
  end
  
  # Called everytime a client subscribes.
  # Juggernaut will only continue if a 200 status code is returned
  # Parameters passed are: session_id, client_id and an array of channels.
  # - checks the user exists, the chat session exists and the user has enough money to play
  # - creates one activity record and one transaction record
  def juggernaut_subscription
    if (@game && @user && @user.has_enough_money_to_play?)
      Activity.juggernaut_join(@user, @game, request.remote_ip, params[:session_id])
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 401
    end
  end

  # Called everytime a specific connection from a subscribed client disconnects. 
  # Parameters passed are session_id, client_id and an array of channels specific to that connection.
  def juggernaut_connection_logout
    Activity.juggernaut_disconnect(@user, @game, request.remote_ip, params[:session_id])
    render :nothing => true
  end
  
  # Called when all connections from a subscribed client are closed.
  # Parameters passed are session_id and client_id.
  def juggernaut_logout
    Activity.juggernaut_close(@user, @game, request.remote_ip, params[:session_id])
    render :nothing => true
  end

  protected
  # Ensure client_id and session_id are passed as params from juggernaut
  def check_juggernaut_params
    render :nothing => true, :status => 401 and return unless params[:client_id]
    render :nothing => true, :status => 401 and return unless params[:session_id]
  end

  # Finds the current game and the user specified in the juggernaut params
  def setup_game_and_user
    @game = Game.in_progress
    @user = User.find(params[:client_id])
  end
end

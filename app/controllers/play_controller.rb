class PlayController < ApplicationController
  before_filter :require_user
  before_filter :check_user_balance, :only => [:show, :test]
  before_filter :check_for_game_in_progress, :only => [:show, :test]
  before_filter :setup_game_from_pip, :only => [:show, :test]
  
  def show; end
  def test; end

  # Ajax method to update the timers and user balance
  def update_page
    time = game_data_from_session
    difference = time_diff_in_minutes(time)

    if current_user.has_enough_money_to_play?
      render :update do |page|
        page['presence_timer'].replace_html render(:partial => 'play/presence_timer', :locals => {:difference => difference})
        page['user_balance'].replace_html render(:partial =>'play/user_balance')
        page['score'].replace_html render(:partial => 'play/score')
      end
    else
      # We check the balance here, not in a filter, so that we can redirect correctly
      flash[:notice] = "You need more money to play"
      render :update do |page|
        page.redirect_to('/funds')
      end
    end
  end

  protected
  # Get the timer from the session, and set it if required
  def game_data_from_session
    current_game = Game.in_progress
    session[current_game.pip][:joined] = Time.now unless session[current_game.pip][:joined]
    return session[current_game.pip][:joined]
  end

  def time_diff_in_minutes(time)
    diff_seconds = (Time.now - time).round
    diff_minutes = diff_seconds / 60
    return diff_minutes
  end

  private
  # Can the user afford to play?
  def check_user_balance
    unless current_user.has_enough_money_to_play?
      flash[:notice] = "You need more money to play"
      redirect_to '/funds'
      return false
    end
  end

  # Only load the page if a game is underway
  def check_for_game_in_progress
    unless Game.in_progress?
      flash[:error] = 'There is no game to play at this time, please try again later'
      redirect_to root_url
    end
  end
  # Setup the user session and game once a user joins the game
  def setup_game_from_pip
    @game = Game.find_by_pip(params[:id])
    if @game.id != Game.in_progress.id
      flash[:error] = 'That game is not currently being played'
      redirect_to root_url
    else
      session[@game.pip] = {}
      session[@game.pip][:joined] = Time.now unless session[@game.pip][:joined]
    end
  end
end

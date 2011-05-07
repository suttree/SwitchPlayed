class BetsController < ApplicationController
  before_filter :require_user

  # Place a bet/buying time in a match
  def create
    @bet = Bet.create(
      :user_id => current_user.id,
      :game_id => params[:game_id],
      :amount => 10.00,
      :period => params[:period],
      :remote_ip => request.remote_ip
    )

    if @bet.save
      current_user.debit(10.00)
      flash.now[:notice] = "Bet placed - good luck!"
    else
      flash.now[:error] = @bet.errors.full_messages.uniq.to_s
    end

    render :update do |page|
      page['bets'].replace_html render(:partial => 'play/bets', :locals => {:flash => flash})
      page['game_information'].replace_html render(:partial =>'play/game_information')
    end
  end
end

class ScoresController < ApplicationController
  before_filter :require_user
  before_filter :setup_game_and_score
  permit 'admin'

  def index; end
  def edit; end

  def update
    @game.score.home_team = params[:score][:home_team]
    @game.score.away_team = params[:score][:away_team]
    if @game.score.save
      flash[:notice] = "Score updated"
      Score.reward_players
    else
      flash[:error] = "Failed to save score :("
    end
    redirect_to game_path(@game)
  end

  protected
  def setup_game_and_score
    @game = Game.find(params[:game_id])
    @game.score = Score.new if @game.score.nil?
  end
end

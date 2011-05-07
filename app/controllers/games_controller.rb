class GamesController < ApplicationController
  before_filter :require_user
  before_filter :setup_game_and_score, :only => [:show, :edit, :update]
  permit 'admin'
  
  def index
    @game = Game.new
    @games = Game.all
  end
  
  def show; end
  def edit; end
  
  def create
    @game = Game.create(params[:game])
    
    if @game.save
      flash[:notice] = "Game saved"
      redirect_to '/games' and return
    else
      @games = Game.all
      flash[:error] = "Failed to save game"
      render :action => :index
    end
  end
  
  def update
    if @game.update_attributes(params[:game])
      flash[:notice] = "Game updated!"
      redirect_to '/games'
    else
      render :action => :edit
    end
  end
  
  protected
  def setup_game_and_score
    @game = Game.find(params[:id])
    @game.score = Score.new if @game.score.nil?
  end
end

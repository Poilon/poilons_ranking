class GamesController < ApplicationController

  def index
    redirect_to '/'
  end

  def show
    @game = Game.find(params[:id])
    redirect_to [@game, :tournaments]
  end

  def new
    @game = Game.new
  end


  def create
    @game = Game.new()
    @game.logo = params[:game][:logo]
    @game.name = params[:game][:name]
    if @game.save
      redirect_to @game
    else
      render :new
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.logo = params[:game][:logo]
    @game.name = params[:game][:name]
    if @game.save
      redirect_to @game
    else
      render :edit
    end
  end

  def compute
    @game = Game.find(params[:id])
    @participants = @game.participants
    @participants.map(&:compute_score)
    redirect_to [@game, :participants]
  end

  private

  def permitted_params
    params.permit(game: [
      :name
    ])
  end
end

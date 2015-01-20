class GamesController < ApplicationController
  before_filter :authenticate_admin!, only: [:new, :create, :edit, :update]

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
    @game = Game.new(permitted_params[:game])
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
    if @game.update_attributes(permitted_params[:game])
      redirect_to @game
    else
      render :edit
    end
  end

  def compute
    @game = Game.find(params[:id])
    Participant.clean
    @participants = @game.participants
    @participants.map(&:compute_score)
    redirect_to [@game, :participants]
  end

  private

  def permitted_params
    params.permit(game: [
      :name,
      :logo,
      :logo_cache
    ])
  end
end

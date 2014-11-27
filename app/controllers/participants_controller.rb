class ParticipantsController < ApplicationController

  def index
    @game = Game.find(params[:game_id])
    @participants = @game.participants.order(:score)
    @participants.map(&:compute_score)
  end

end

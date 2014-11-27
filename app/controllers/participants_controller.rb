class ParticipantsController < ApplicationController

  def index
    @game = Game.find(params[:game_id])
    @participants = @game.participants
    # @participants.map(&:compute_score)
    @participants = @participants.order(score: :desc).group_by(&:score)
  end

end

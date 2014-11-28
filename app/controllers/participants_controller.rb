class ParticipantsController < ApplicationController
  def index
    @game = Game.find(params[:game_id])
    @participants = @game.participants
    @participants = @participants.order(score: :desc).group_by(&:score)
  end

  def edit
    @participant = Participant.find(params[:id])
    @game = Game.find(params[:game_id])
  end

  def update
    @game = Game.find(params[:game_id])
    @participant = Participant.find(params[:id])
    if @participant.update_attributes(permitted_params[:participant])
      redirect_to [@game, :participants]
    else
      render :edit
    end
  end

  private

  def permitted_params
    params.permit(participant: [
      :name
    ])
  end
end

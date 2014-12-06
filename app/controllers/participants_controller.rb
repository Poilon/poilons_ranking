class ParticipantsController < ApplicationController
  
  def index
    @game = Game.find(params[:game_id])
    @country = params[:country]
    @participants = @country ? @game.participants.where(country: @country) : @game.participants
    @participants_by_score = @participants.order(score: :desc).group_by(&:score)
  end

  def edit
    @participant = Participant.find(params[:id])
    @game = Game.find(params[:game_id])
    global_rank = 0
    arr = []
    @game.participants.order(score: :desc).group_by(&:score)
  end

  def update
    @game = Game.find(params[:game_id])
    @participant = Participant.find(params[:id])
    @participant.name = permitted_params[:participant][:name]
    @participant.location = permitted_params[:participant][:location]
    if @participant.update_attributes(permitted_params[:participant])
      redirect_to [@game, :participants]
    else
      render :edit
    end
  end

  private

  def permitted_params
    params.permit(participant: [
      :name,
      :location
    ])
  end
end

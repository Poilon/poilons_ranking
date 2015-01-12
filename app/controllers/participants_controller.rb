class ParticipantsController < ApplicationController
  
  def index
    @game = Game.find(params[:game_id])

    respond_to do |format|
      format.html
      format.json do
        @participants = get_participants_regarding_location
        json_participants = get_json_for_angular
        render json: json_participants
      end
    end
  end

  def edit
    @participant = Participant.find(params[:id])
    @results = @participant.results
    @game = Game.find(params[:game_id])
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

  def get_json_for_angular
    rank_method = get_rank_method
    @participants.order(score: :desc).map do |participant|
      participant_json = participant.attributes.merge(rank: participant.send(rank_method))
      participant_json['country_code'] = CountryCodesList.mapping(participant.country)
      %w(created_at updated_at score longitude latitude location).each do |useless_field|
        participant_json.delete(useless_field)
      end
      participant_json
    end
  end

  def get_rank_method
    rank_method = 'global_rank'
    rank_method = 'country_rank' if params[:country]
    rank_method = 'city_rank' if params[:city]
    rank_method
  end

  def get_participants_regarding_location
    country = params[:country]
    state = params[:state]
    sub_state = params[:sub_state]
    city = params[:city]
    participants = @game.participants
    participants = participants.where(country: country) if country
    participants = participants.where(state: state) if state
    participants = participants.where(sub_state: sub_state) if sub_state
    participants = participants.where(city: city) if city
    participants
  end

  def permitted_params
    params.permit(participant: [
      :name,
      :location
    ])
  end
end

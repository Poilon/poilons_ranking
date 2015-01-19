class ParticipantsController < ApplicationController
  before_filter :authenticate_admin!, only: [:edit, :update]


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

  def show
    @participant = Participant.find(params[:id])
    @results = @participant.results
    @game = Game.find(params[:game_id])
    @game.participants.order(score: :desc).group_by(&:score)
  end


  def update
    @game = Game.find(params[:game_id])
    @participant = Participant.find(params[:id])
    @participant.location = permitted_params[:participant][:location]
    @participant.twitter = permitted_params[:participant][:twitter]
    @participant.youtube = permitted_params[:participant][:youtube]
    if permitted_params[:participant][:name].present? && @participant.name != permitted_params[:participant][:name]
      @participant.name = permitted_params[:participant][:name]
      @participant.merge_process if Participant.find_by_name(@participant.name)
    end
    if !@participant.persisted? || @participant.save 
      redirect_to [@game, @participant]
    else
      render :edit
    end
  end

  private

  def get_json_for_angular
    rank_method = get_rank_method
    game_slug = @game.slug
    @participants.order(score: :desc, name: :asc).map do |participant|
      participant_json = participant.attributes.merge(rank: participant.send(rank_method))
      participant_json['country_code'] = CountryCodesList.mapping(participant.country)
      participant_json['game_slug'] = game_slug
      %w(created_at updated_at score longitude latitude location).each do |useless_field|
        participant_json.delete(useless_field)
      end
      participant_json
    end
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
      :location,
      :twitter,
      :youtube
    ])
  end
end

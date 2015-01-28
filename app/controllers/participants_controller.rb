class ParticipantsController < ApplicationController
  before_filter :authenticate_admin!, only: [:edit, :update]

  def index
    @game = Game.find(params[:game_id])

    respond_to do |format|
      format.html
      format.json do
        @participants = get_participants_regarding_location
        @participants = get_participants_regarding_character if params[:character]
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
  end

  def update
    @game = Game.find(params[:game_id])
    @participant = Participant.find(params[:id])
    @participant.location = permitted_params[:participant][:location]
    @participant.twitter = permitted_params[:participant][:twitter]
    @participant.youtube = permitted_params[:participant][:youtube]
    @participant.wiki = permitted_params[:participant][:wiki]
    add_characters_to_participant
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

  def add_characters_to_participant
    @participant.characters = []
    rank = 1
    permitted_params[:participant][:character_names].split("\n").map(&:strip).each do |name|
      char = Character.where(game_id: @game.id).find_by_slug(name.downcase)
      CharacterParticipant.create(rank: rank, participant_id: @participant.id, character_id: char.id) unless char.blank?
      rank += 1
    end
  end

  def get_json_for_angular
    rank_method = get_rank_method
    game_slug = @game.slug
    character_name = params[:character]
    @participants.order(score: :desc, name: :asc).map do |participant|
      participant_json = participant.attributes
      participant_json['rank'] = participant.send(rank_method) unless character_name.present?
      participant_json['rank'] = participant.character_rank(character_name) if character_name.present?
      participant_json['country_code'] = CountryCodesList.mapping(participant.country)
      participant_json['game_slug'] = game_slug
      participant.characters.count.times do |i|
        participant_json["character#{i + 1}_slug"] = CharacterParticipant.where(participant_id: participant.id).find_by_rank(i + 1).character.slug
        participant_json["character#{i + 1}_img"] = ActionController::Base.helpers.asset_path("#{game_slug}/#{CharacterParticipant.where(participant_id: participant.id).find_by_rank(i + 1).character.slug}.png")
      end  
      %w(created_at updated_at score longitude latitude location state sub_state city twitter youtube wiki id).each do |useless_field|
        participant_json.delete(useless_field)
      end
      participant_json
    end unless @participants.blank?
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

  def get_participants_regarding_character
    character = @game.characters.find_by_slug(params[:character])
    if character
      character.participants
    else
      @game.participants
    end
  end

  def permitted_params
    params.permit(participant: [
      :name,
      :location,
      :twitter,
      :youtube,
      :wiki,
      :character_names
    ])
  end
end

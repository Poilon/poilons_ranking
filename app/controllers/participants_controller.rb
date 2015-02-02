class ParticipantsController < ApplicationController
  before_filter :authenticate_admin!, only: [:edit, :update]

  def index
    @game = Game.find(params[:game_id])

    respond_to do |format|
      format.html
      format.json do
        @participants = get_participants_regarding_location if params[:character].blank? && params[:country].present?
        @participants = get_participants_regarding_character if params[:character].present?
        if @participants.blank?
          json_participants = Rails.cache.fetch("#{@game.id}_participants") do
            @participants = @game.participants
            get_json_for_angular
          end
        else
          json_participants = get_json_for_angular
        end
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
    @participant          = Participant.find(params[:id])
    @participant.location = permitted_params[:participant][:location]
    @participant.twitter  = permitted_params[:participant][:twitter]
    @participant.youtube  = permitted_params[:participant][:youtube]
    @participant.wiki     = permitted_params[:participant][:wiki]
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
    rank = 1
    global_rank = 1
    character_img_matcher = {}
    @game.characters.each { |c| character_img_matcher[c.slug] = ActionController::Base.helpers.asset_path("#{game_slug}/#{c.slug}.png")}
    @participants.order(score: :desc, name: :asc).map do |participant|
      rank = global_rank if @old_score && @old_score > participant.score
      global_rank += 1
      @old_score = participant.score
      participant_json = {}
      participant_json['rank'] = rank
      participant_json['game_slug'] = game_slug
      %w(country name slug country_code).each do |attribute|
        participant_json[attribute] = participant.send(attribute.to_sym)
      end
      participant.character_participants.each do |cp|
        participant_json["character#{cp.rank}_slug"] = cp.character.slug
        participant_json["character#{cp.rank}_img"] = character_img_matcher[cp.character.slug]
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
    participants = participants.where(country:   country)   if country
    participants = participants.where(state:     state)     if state
    participants = participants.where(sub_state: sub_state) if sub_state
    participants = participants.where(city:      city)      if city
    participants
  end

  def get_participants_regarding_character
    character = @game.characters.find_by_slug(params[:character])
    if character && params[:main]
      character.participants.joins(:character_participants).where('character_participants.rank = 1').uniq    elsif character
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

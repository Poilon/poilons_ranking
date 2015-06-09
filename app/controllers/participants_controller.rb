class ParticipantsController < ApplicationController
  before_filter :authenticate_admin!, only: [:edit, :update]

  def index
    @game = Game.find(params[:game_id])

    respond_to do |format|
      format.html
      format.json do
        @participants = @game.participants.filter_by_params(params)
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
    @participant          = Participant.find(params[:id])
    @participant.location = permitted_params[:participant][:location]
    @participant.twitter  = permitted_params[:participant][:twitter]
    @participant.youtube  = permitted_params[:participant][:youtube]
    @participant.wiki     = permitted_params[:participant][:wiki]
    add_characters_to_participant
    add_teams_to_participant
    @participant.characters_index = permitted_params[:participant][:character_names].split("\n").map(&:strip).join(',')
    @participant.teams_index = @participant.teams.map{ |c| c.slug }.join(',')
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

  def add_teams_to_participant
    @participant.teams = []
    permitted_params[:participant][:team_names].split("\n").map(&:strip).each do |name|
      unless team = Team.where(game_id: @game.id).find_by_slug(name.parameterize)
        team = Team.create(game_id: @game.id, name: name)
      end
      @participant.teams << team
    end
  end

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
    game_slug = @game.slug
    character_img_matcher = {}
    @game.characters.each { |c| character_img_matcher[c.slug] = ActionController::Base.helpers.asset_path("#{game_slug}/#{c.slug}.png")}
    global_rank = 1
    rank = 1
    @participants.order(score: :desc, name: :asc).map do |participant|
      rank = global_rank if @old_score && @old_score > participant.score
      global_rank += 1
      @old_score = participant.score
      participant_json = participant.attributes.merge(rank: rank)
      participant.characters_index.split(',').each_with_index do |cp, i|
        participant_json["character#{i + 1}_slug"] = cp
        participant_json["character#{i + 1}_img"] = character_img_matcher[cp]
      end if participant.characters_index
      participant.teams_index.split(',').each_with_index do |team, i|
        participant_json["team#{i + 1}_slug"] = team.split(';').first
        participant_json["team#{i + 1}_name"] = team.split(';').last
      end if participant.teams_index
      participant_json['country_code'] = CountryCodesList.mapping(participant.country)
      participant_json['game_slug'] = game_slug
      participant_json
    end
  end

  def permitted_params
    params.permit(participant: [
      :name,
      :location,
      :twitter,
      :youtube,
      :wiki,
      :character_names,
      :team_names
    ])
  end
end

class TournamentsController < ApplicationController
  before_filter :authenticate_admin!, only: [:edit, :update]
  rescue_from ActiveResource::UnauthorizedAccess, with: :access_denied

  def index
    @game = Game.find(params[:game_id])
    respond_to do |format|
      format.html
      format.json do
        render json: get_json_for_angular_tournaments
      end
    end
  end

  def new
    @game = Game.find(params[:game_id])
    @tournament = Tournament.new
  end

  def create
    @game = Game.find(params[:game_id])
    challonge_import if permitted_params[:api_key].present? && permitted_params[:user_name].present?
    Rails.cache.delete("#{@game.id}_participants")
    if params[:raw]
      raw_import
    else
      redirect_to [@game, :tournaments]
    end
  end

  def show
    @game = Game.find(params[:game_id])
    @tournament = Tournament.find(params[:id])
    @results = @tournament.results
    respond_to do |format|
      format.html
      format.json do
        render json: get_json_for_angular_results
      end
    end
  end

  def edit
    @tournament = Tournament.find(params[:id])
    @raw = @tournament.to_raw
    @game = Game.find(params[:game_id])
  end

  def update
    game = Game.find(params[:game_id])
    tournament = Tournament.find(params[:id])
    old_participants = tournament.results.map(&:participant)
    tournament.name = permitted_params[:tournament][:name]
    tournament.multiplier = permitted_params[:tournament][:multiplier]
    tournament.date = (permitted_params[:tournament]['date(1i)'] + '-' + permitted_params[:tournament]['date(2i)'] + '-' + permitted_params[:tournament]['date(3i)']).to_date
    raw = params[:raw][:to_s]
    if raw != tournament.to_raw && raw.present?
      tournament.results.destroy_all
      tournament.construct_results(raw)
    end
    if tournament.valid?
      if raw.blank?
        tournament.destroy
      else
        tournament.save
        tournament.compute_scores
        old_participants.map(&:compute_score)
      end
      Participant.clean
      Rails.cache.delete("#{@game.id}_participants")
      redirect_to [game, tournament]
    else
      render :edit
    end
  end

  private

  def get_json_for_angular_tournaments
    game_slug = @game.slug
    @game.tournaments.order(created_at: :desc).map do |tournament|
      tournament_json = tournament.attributes.merge(game_slug: game_slug)
      %w(created_at updated_at).each do |useless_field|
        tournament_json.delete(useless_field)
      end
      tournament_json
    end
  end

  def get_json_for_angular_results
    game_slug = @game.slug
    json_results = @results.order(rank: :asc).map do |result|
      {
        rank: result.rank,
        participant_slug: result.participant ? result.participant.slug : '',
        participant_name: result.participant ? result.participant.name : '',
        game_slug: game_slug,
        country_code: result.participant ? CountryCodesList.mapping(result.participant.country) : '',
        country: result.participant ? result.participant.country : ''
      }
    end
  end

  def access_denied
    flash[:error] = 'Bad key or username'
    @tournament = Tournament.new

    render :new
  end

  def raw_import
    @tournament = Tournament.new(permitted_params[:tournament].merge(game_id: @game.id))
    if @tournament.save
      @tournament.update_attribute(:total_participants, @tournament.results.count)
      @tournament.construct_results(params[:raw][:tournament])
      @tournament.compute_scores
      redirect_to [:edit, @game, @tournament]
    else
      flash[:error] = 'Invalid tournament'
    end
  end

  def challonge_import
    Challonge::API.username = permitted_params[:user_name]
    Challonge::API.key = permitted_params[:api_key]

    challonge_tournaments = Challonge::Tournament.find(:all, params: { status: 'complete' } );
    challonge_tournaments.each do |challonge_tournament|
      tournament = Tournament.find_by_remote_id(challonge_tournament.id)
      unless tournament
        tournament = Tournament.create(name: challonge_tournament.name, multiplier: 100, game_id: @game.id, remote_id: challonge_tournament.id)
        challonge_tournament.participants.each do |challonge_participant|
          participant = Participant.where(game_id: @game.id).find_by_name(challonge_participant.name)
          participant = Participant.create(name: challonge_participant.name, game_id: @game.id) unless participant
          result = Result.create(participant_id: participant.id, tournament_id: tournament.id, rank: challonge_participant.final_rank) unless challonge_participant.final_rank.blank?
        end
        tournament.update_attribute(:total_participants, tournament.results.count)
      end
      tournament.update_attribute(:multiplier, tournament.define_mulitplier)
      tournament.reload.compute_scores
    end
  end


  private

  def permitted_params
    params.permit(:api_key, :user_name, tournament: [
      :name,
      :multiplier,
      :date
    ])
  end
end

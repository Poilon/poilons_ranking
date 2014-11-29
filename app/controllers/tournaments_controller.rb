class TournamentsController < ApplicationController
  rescue_from ActiveResource::UnauthorizedAccess, with: :access_denied

  def index
    @game = Game.find(params[:game_id])
    @tournaments = @game.tournaments.order(:created_at)
  end

  def new
    @game = Game.find(params[:game_id])
    @tournament = Tournament.new
  end

  def create
    Challonge::API.username = params[:user_name]
    Challonge::API.key = params[:api_key]
    @game = Game.find(params[:game_id])

    challonge_tournaments = Challonge::Tournament.find(:all, params: { status: 'complete' } );
    challonge_tournaments.each do |challonge_tournament|
      tournament = Tournament.find_by_remote_id(challonge_tournament.id)
      unless tournament
        tournament = Tournament.create(name: challonge_tournament.name, multiplier: 100, game_id: @game.id, remote_id: challonge_tournament.id)
        challonge_tournament.participants.each do |challonge_participant|
          participant = Participant.find_by_name(challonge_participant.name)
          participant = Participant.create(name: challonge_participant.name, game_id: @game.id) unless participant
          result = Result.create(participant_id: participant.id, tournament_id: tournament.id, rank: challonge_participant.final_rank) unless challonge_participant.final_rank.blank?
        end
      end
    end
    redirect_to @game
  end

  def edit
    @tournament = Tournament.find(params[:id])
    @game = Game.find(params[:game_id])
  end

  def update
    @game = Game.find(params[:game_id])
    @tournament = Tournament.find(params[:id])
    @tournament.multiplier = params[:tournament][:multiplier]
    if @tournament.save
      redirect_to @game
    else
      render :edit
    end
  end

  def access_denied
    flash[:error] = 'Bad key or username'
    @tournament = Tournament.new
    render :new
  end
end

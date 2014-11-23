class TournamentsController < ApplicationController
  rescue_from ActiveResource::UnauthorizedAccess, with: :access_denied

  def new
    @tournament = Tournament.new
  end

  def create
    Challonge::API.username = 'LeFrenchMelee'
    Challonge::API.key = '68hnQ6wcF2ZWFFIneu4nwrJsYXxdOpAM4fn4Iwt'

    challonge_tournaments = Challonge::Tournament.find(:all, params: { status: 'complete' } )
    challonge_tournaments.each do |challonge_tournament|
      tournament = Tournament.find_by_name(challonge_tournament.name)
      unless tournament
        tournament = Tournament.create(name: challonge_tournament.name, multiplier: 100, game_id: Game.find_by_name('Super Smash Bros. Melee').id)      
        challonge_tournament.participants.each do |challonge_participant|
          participant = Participant.find_by_name(challonge_participant.name)
          participant = Participant.create(name: challonge_participant.name) unless participant
          result = Result.create(participant_id: participant.id, tournament_id: tournament.id, rank: challonge_participant.final_rank)
        end
      end
    end
    redirect_to :home
  end

  def access_denied
    flash[:error] = 'Bad key or username'
    render :new
  end
end

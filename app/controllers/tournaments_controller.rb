class TournamentsController < ApplicationController

  def generate_from_challonge
    challonge_tournaments = Challonge::Tournament.find(:all, params: { status: 'complete' } )
    challonge_tournaments.each do |challonge_tournament|
      tournament = Tournament.find_by_name(challonge_tournament.name)
      unless tournament
        tournament = Tournament.create(name: challonge_tournament.name, multiplier: 100)      
        challonge_tournament.participants.each do |challonge_participant|
          participant = Participant.find_by_name(challonge_participant.name)
          participant = Participant.create(name: challonge_participant.name) unless participant
          result = Result.create(participant_id: participant.id, tournament_id: tournament.id, rank: challonge_participant.final_rank)
        end
      end
    end
  end
end

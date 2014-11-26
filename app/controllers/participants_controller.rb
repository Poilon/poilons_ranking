class ParticipantsController < ApplicationController

  def index
    @game = Game.find(params[:game_id])
    players_list = {}
    @game.participants.each do |participant|
      sum = 0
      players_list[participant.name] = participant.results.map do |result|
        sum += Float(result.tournament.multiplier) / Float(result.rank) if !result.tournament.blank? && !result.rank.blank?
        sum
      end.last
    end
    index = 1
    final_results = {}
    @participants = players_list.sort_by{|k, v| v}.reverse
  end

end

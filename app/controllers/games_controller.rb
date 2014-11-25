class GamesController < ApplicationController

  def show
    @game = Game.find(params[:id])
  end
  def ranking
    players_list = {}
    Participant.all.each do |participant|
      sum = 0
      players_list[participant.name] = participant.results.map do |result|
        sum += Float(result.tournament.multiplier) / Float(result.rank) if !result.tournament.blank? && !result.rank.blank?
        sum
      end.last
    end
    index = 1
    final_results = {}
    @ranking = players_list.sort_by{|k, v| v}.reverse
  end
end

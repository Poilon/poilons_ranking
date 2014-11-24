class HomeController < ApplicationController

  def show

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
    @ranking = players_list.sort_by{|k, v| v}.map(&:first).reverse
    #players_list.sort_by{|k, v|v}.map{|k, v|final_results[index] = v.map(&:first) + [v.first.last]; index += 1}
    #final_results.sort_by{|k, v| v.last}.reverse
  end
end

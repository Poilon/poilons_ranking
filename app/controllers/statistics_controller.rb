class StatisticsController < ApplicationController

  def index
    @game = Game.find(params[:game_id])
    @nb_participants = @game.participants.count
    @character_stats = @game.characters.map do |c|
      [
        c.name,
        ((c.participants.count.to_f / @game.characters.joins(:participants).count.to_f) * 100).round(2),
        c.participants.order('score desc').first.name
      ] unless c.participants.blank?
    end
  end
end
